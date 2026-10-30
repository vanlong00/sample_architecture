import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:yandex_native_custom/my_yandex_native_ad_controller.dart';

import '../ad_unit_ids.dart';
import '../ads_service.dart';
import '../native_ad_template.dart';
import 'ad_controller.dart';
import 'slot_ad.dart';

final class AdmobNativeLoader implements SlotAdLoader {
  AdmobNativeLoader(this._ads, this._options);

  final AdsService _ads;

  /// Builds a fresh `customOptions` map (see `nativeAdOptions`).
  final Map<String, Object> Function() _options;

  @override
  Future<SlotAd?> load({
    required void Function(SlotAd ad) stage,
    required VoidCallback onClicked,
  }) {
    final done = Completer<SlotAd?>();
    admob.NativeAd(
      adUnitId: AdUnitIds.native,
      factoryId: NativeAdFactoryIds.admob,
      customOptions: _options(),
      // The AD badge owns the top-right corner of the layout.
      nativeAdOptions: admob.NativeAdOptions(
        adChoicesPlacement: admob.AdChoicesPlacement.topLeftCorner,
      ),
      request: _ads.adRequest(),
      listener: admob.NativeAdListener(
        onAdLoaded: (ad) => done.complete(AdmobSlotAd(ad as admob.NativeAd)),
        onAdFailedToLoad: (ad, error) => _fail(done, ad, error),
        onAdClicked: (_) => onClicked(),
      ),
    ).load();
    return done.future;
  }

  @override
  void dispose() {}
}

void _fail(Completer<SlotAd?> done, admob.Ad ad, admob.LoadAdError error) {
  debugPrint('[Ads] ${ad.runtimeType} load fail: ${error.message}');
  ad.dispose();
  done.complete(null);
}

/// Every load goes through one [MyYandexNativeAdController]. See
/// [YandexNativeSlotAd] for why.
final class YandexNativeLoader implements SlotAdLoader {
  YandexNativeLoader(this._unitId, this._options);

  final String _unitId;

  /// Builds a fresh `customOptions` map (see `nativeAdOptions`).
  final Map<String, Object> Function() _options;

  MyYandexNativeAdController? _controller;
  VoidCallback? _onClicked;

  /// The plugin never answers when the native side has no controller (an
  /// unregistered factory), so a missing answer counts as a failure
  /// and goes through the retry backoff.
  static const Duration _answerTimeout = Duration(seconds: 30);

  @override
  Future<SlotAd?> load({
    required void Function(SlotAd ad) stage,
    required VoidCallback onClicked,
  }) async {
    _onClicked = onClicked;
    var controller = _controller;
    if (controller == null) {
      controller = _controller = MyYandexNativeAdController(
        adUnitID: _unitId,
        adFactoryId: NativeAdFactoryIds.yandex,
        native_ad_options: _options(),
        onAdClicked: () => _onClicked?.call(),
      );
      await _nativeControllerCreated();
    }
    final result = controller.stateChanged
        .firstWhere((state) => state != AdLoadState.loading)
        .timeout(_answerTimeout, onTimeout: () => AdLoadState.loadError);
    controller.loadNewAd();
    if (await result == AdLoadState.loadError) {
      debugPrint('[Ads] yandex native load fail');
      return null;
    }
    return YandexNativeSlotAd(controller);
  }

  /// The constructor asks the plugin to create the native controller, and
  /// that controller registers the channel `loadNewAd` goes to. The platform
  /// side looks up a channel's handler when the message arrives but runs the
  /// create call later, so an immediate `loadNewAd` meets no handler and is
  /// dropped (MissingPluginException). The plugin channel answers
  /// `getPlatformVersion` only after it has run the create call queued
  /// before it.
  static Future<void> _nativeControllerCreated() => const MethodChannel(
    'yandex_native_custom',
  ).invokeMethod<String>('getPlatformVersion');

  @override
  void dispose() => _controller?.dispose();
}
