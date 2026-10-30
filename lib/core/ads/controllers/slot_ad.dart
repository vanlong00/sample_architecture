import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:yandex_native_custom/my_yandex_native_ad.dart';
import 'package:yandex_native_custom/my_yandex_native_ad_controller.dart';

/// A loaded native ad of either network, as an [AdController]
/// holds it. Each case knows how to draw itself and how to release itself.
///
/// [build] returns a platform view, so the widget it returns must be in the
/// tree at most once at a time (see the owner queue in [AdController]).
sealed class SlotAd {
  const SlotAd();

  Widget build();

  void dispose();
}

final class AdmobSlotAd extends SlotAd {
  const AdmobSlotAd(this.ad);

  final admob.AdWithView ad;

  @override
  Widget build() => admob.AdWidget(ad: ad);

  @override
  void dispose() => ad.dispose();
}

/// One load of a Yandex native ad.
///
/// Every load of a slot goes through the same [controller]: the plugin
/// replaces the controller's native view on each load, and its `dispose()`
/// does not free the native side, so a controller per load would leak one
/// native ad view per refresh. A new [YandexNativeSlotAd] per load still
/// gives each load its own widget identity, so the platform view is created
/// again and picks up the new native view.
final class YandexNativeSlotAd extends SlotAd {
  // Not const: two loads with the same controller must stay distinct keys.
  YandexNativeSlotAd(this.controller);

  final MyYandexNativeAdController controller;

  @override
  Widget build() => MyYandexNativeAdView(
    controller: controller,
    loading: const SizedBox.shrink(),
    error: const SizedBox.shrink(),
  );

  /// The shared [controller] belongs to the loader, which releases it with
  /// the slot.
  @override
  void dispose() {}
}
