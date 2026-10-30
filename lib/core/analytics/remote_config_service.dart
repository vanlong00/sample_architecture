import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../ads/more_app.dart';

/// Remote Config keys. Declared here so string literals are not scattered in
/// the code: one wrong character silently returns the default.
class RemoteConfigKeys {
  const RemoteConfigKeys._();

  /// Turns the forced update screen on or off.
  static const String forceUpdate = 'force_update';

  /// Minimum accepted version (semver, for example "1.2.0").
  static const String minSupportedVersion = 'min_supported_version';

  /// Master ads switch: off removes every ad slot.
  static const String adsEnabled = 'ads_enabled';

  /// The interstitial shows only on the N-th request.
  static const String maxAdRequests = 'max_ad_requests';

  /// JSON array of the "house" apps. See [RemoteConfigService.getMoreApps].
  static const String moreApps = 'more_apps';

  /// How many impressions one native ad is reused for before a new one loads.
  static const String nativeMaxImpressions = 'native_max_impressions';

  /// Maximum age of a native ad, in minutes.
  static const String nativeMaxAgeMinutes = 'native_max_age_minutes';

  /// Turns only the in-list native ad slots on or off.
  static const String nativeListAdsEnabled = 'native_list_ads_enabled';
}

// Phase 2 replaces the body with Firebase Remote Config (same public API).
@lazySingleton
class RemoteConfigService {
  static const Map<String, Object> defaults = <String, Object>{
    RemoteConfigKeys.forceUpdate: false,
    RemoteConfigKeys.minSupportedVersion: '1.0.0',
    RemoteConfigKeys.adsEnabled: true,
    RemoteConfigKeys.maxAdRequests: 3,
    RemoteConfigKeys.moreApps: '[]',
    RemoteConfigKeys.nativeMaxImpressions: 3,
    RemoteConfigKeys.nativeMaxAgeMinutes: 30,
    RemoteConfigKeys.nativeListAdsEnabled: true,
  };

  /// Unknown key (or a value of another type) -> the type's zero value.
  bool getBool(String key) {
    final v = defaults[key];
    return v is bool ? v : false;
  }

  int getInt(String key) {
    final v = defaults[key];
    return v is int ? v : 0;
  }

  String getString(String key) {
    final v = defaults[key];
    return v is String ? v : '';
  }

  List<MoreApp> getMoreApps() =>
      parseMoreApps(getString(RemoteConfigKeys.moreApps));

  /// Fails open: malformed JSON only leaves the ad slot empty.
  @visibleForTesting
  static List<MoreApp> parseMoreApps(String raw) {
    try {
      if (raw.isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(MoreApp.fromJson)
          .toList(growable: false);
    } catch (error) {
      debugPrint('[RemoteConfig] more_apps parse fail: $error');
      return const [];
    }
  }
}
