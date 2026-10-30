import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../storage/local_store.dart';

/// The ad SDK that serves every ad format in this app run.
enum AdNetwork { admob, yandex }

/// Countries where Yandex replaces AdMob for every format.
const Set<String> kYandexCountries = {'RU', 'KZ', 'KG', 'UZ'};

/// Picks the network for [country] (ISO 3166 alpha-2, any case).
AdNetwork networkFor(String? country) {
  if (country == null) return AdNetwork.admob;
  return kYandexCountries.contains(country.toUpperCase())
      ? AdNetwork.yandex
      : AdNetwork.admob;
}

/// Reads the country from a `myIPHeader` body (`{"cf-ipcountry":"VN"}`).
///
/// Accepts a decoded map or a raw string: Dio decodes only when the response
/// says `application/json`. Cloudflare sends `XX` (unknown) and `T1` (Tor),
/// which are not countries and are rejected.
String? parseCountry(Object? body) {
  final Object? json;
  try {
    json = body is String ? jsonDecode(body) : body;
  } on FormatException {
    return null;
  }
  if (json is! Map) return null;
  final value = json['cf-ipcountry'];
  if (value is! String) return null;
  final country = value.trim().toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(country)) return null;
  if (country == 'XX' || country == 'T1') return null;
  return country;
}

/// Finds the user's country from their IP, for [networkFor].
///
/// Uses the download Dio (`@Named('download')`): no cache, no token, and no
/// API base URL. The lookup host is not the app API, so it must not get the
/// API interceptors.
@lazySingleton
class AdCountryLookup {
  AdCountryLookup(@Named('download') this._dio, this._store);

  final Dio _dio;
  final LocalStore _store;

  /// https: the main network security config forbids cleartext. The host
  /// serves the same JSON over https.
  static const String url = 'https://master.getdata.one/myIPHeader';

  /// Settings key of the last country the lookup returned.
  static const String cacheKey = 'ads_country';

  /// Ads init waits on this lookup, so a slow network must not hold the
  /// first ad for long. A timeout falls back to [cacheKey].
  static const Duration timeout = Duration(seconds: 3);

  /// Debug-only override so Yandex can be tested from any country:
  /// `--dart-define=ADS_FORCE_COUNTRY=RU`. Ignored in release builds.
  static const String _forced = String.fromEnvironment('ADS_FORCE_COUNTRY');

  /// The country, or `null` when the lookup fails and nothing is cached.
  Future<String?> country() async {
    if (kDebugMode && _forced.isNotEmpty) return _forced.toUpperCase();
    try {
      final response = await _dio.get<Object?>(url).timeout(timeout);
      final country = parseCountry(response.data);
      if (country != null) {
        await _writeCache(country);
        return country;
      }
    } catch (error) {
      debugPrint('[Ads] country lookup fail: $error');
    }
    return _readCache();
  }

  // The store is not open in widget tests; a missing cache is not an error.
  String? _readCache() {
    try {
      return _store.read<String>(StoreBoxes.settings, cacheKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String country) async {
    try {
      await _store.write<String>(StoreBoxes.settings, cacheKey, country);
    } catch (_) {}
  }
}
