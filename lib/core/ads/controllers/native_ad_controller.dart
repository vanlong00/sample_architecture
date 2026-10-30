import 'package:flutter/material.dart';

import '../../analytics/remote_config_service.dart';
import '../ad_network.dart';
import '../ads_service.dart';
import '../../theme/app_colors.dart';
import '../native_ad_template.dart';
import 'ad_controller.dart';
import 'slot_ad_loaders.dart';

/// Native ad placements. Each slot has its own controller (one ad).
///
/// Separate slots instead of one shared ad: sharing would mean that opening
/// the detail screen while the list shows the ad puts one ad in two platform
/// views (see [AdController]).
enum NativeAdSlot {
  modList(NativeAdTemplate.medium),

  /// Separate from [modList]: a screen pushed over a mounted list must not
  /// share its ad (one ad object never sits in two `AdWidget`s at once).
  modSearch(NativeAdTemplate.medium),
  modDetail(NativeAdTemplate.medium),
  favorites(NativeAdTemplate.medium),
  downloaded(NativeAdTemplate.medium);

  const NativeAdSlot(this.template);

  final NativeAdTemplate template;
}

/// Holds one native ad for [slot], reused across widget mounts.
///
/// Refresh policy: one ad serves at most
/// [RemoteConfigKeys.nativeMaxImpressions] impressions and lives at most
/// [RemoteConfigKeys.nativeMaxAgeMinutes] minutes. Past either limit a new ad
/// loads, and the old ad stays in place until the new one arrives (no empty
/// slot in between).
///
/// Without this, every mount would send a request, and frequent tab switches
/// would fire requests nonstop. That drains battery and network, and SDK
/// frequency limits make no-fill more likely.
class NativeAdController extends AdController {
  /// [loaderFor] replaces the SDK loaders in tests.
  NativeAdController(
    this._ads,
    this._remoteConfig,
    this.slot, {
    SlotAdLoader Function(AdNetwork network)? loaderFor,
  }) : _testLoaderFor = loaderFor,
       super(_ads);

  final AdsService _ads;
  final SlotAdLoader Function(AdNetwork network)? _testLoaderFor;

  /// Theme data the native layouts take. `NativeAdView` sets them before the
  /// first load.
  ColorScheme _scheme = ColorScheme.fromSeed(seedColor: AppColors.seed);
  String _adLabel = 'Ad';

  void updateTheme(ColorScheme scheme, String adLabel) {
    _scheme = scheme;
    _adLabel = adLabel;
  }

  Map<String, Object> _options() =>
      nativeAdOptions(slot.template, _scheme, _adLabel);

  @override
  SlotAdLoader createLoader(AdNetwork network) =>
      _testLoaderFor?.call(network) ??
      switch (network) {
        AdNetwork.admob => AdmobNativeLoader(_ads, _options),
        AdNetwork.yandex => YandexNativeLoader(
          _ads.yandexUnits!.native,
          _options,
        ),
      };

  final RemoteConfigService _remoteConfig;
  final NativeAdSlot slot;

  int _impressions = 0;
  DateTime? _loadedAt;

  int get _maxImpressions {
    final value = _remoteConfig.getInt(RemoteConfigKeys.nativeMaxImpressions);
    // 0 (key missing in the console, the SDK returns 0) would mean a new ad on
    // every mount. Clamp to 1 so the cache always takes effect.
    return value < 1 ? 1 : value;
  }

  Duration get _maxAge {
    final minutes = _remoteConfig.getInt(RemoteConfigKeys.nativeMaxAgeMinutes);
    return Duration(minutes: minutes < 1 ? 1 : minutes);
  }

  bool get _isStale {
    final loadedAt = _loadedAt;
    if (loadedAt == null) return true;
    return _impressions >= _maxImpressions ||
        DateTime.now().difference(loadedAt) > _maxAge;
  }

  @override
  void onAcquired() {
    if (ad != null && !_isStale) {
      _impressions++;
      return;
    }
    startLoad();
  }

  @override
  void didLoad() {
    _impressions = 1;
    _loadedAt = DateTime.now();
  }

  /// A clicked ad has no display value left. Load another one for the next
  /// impression.
  @override
  void onClicked() => _impressions = _maxImpressions;
}
