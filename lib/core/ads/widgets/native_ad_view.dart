import 'package:flutter/material.dart';

import '../../l10n/l10n_ext.dart';
import '../ads_service.dart';
import '../controllers/native_ad_controller.dart';
import '../native_ad_template.dart';
import 'more_app_house_ad.dart';
import 'slot_ad_stack.dart';

/// Native ad slot drawn by the app's own native layouts (`NativeAdFactory`
/// in `MainActivity.kt`), for whichever network
/// [AdsService.network] picked. The layouts copy [MoreAppHouseAd].
///
/// The ad belongs to the [NativeAdController] of [slot] in [AdsService], not
/// to this widget. It is reused across mounts and reloads only when it runs
/// out of impressions or expires (see the controller).
class NativeAdView extends StatefulWidget {
  const NativeAdView({required this.slot, this.poolIndex = 0, super.key});

  final NativeAdSlot slot;

  /// Index of this cell in the [slot] pool. Only meaningful for lists with
  /// several ad cells (see `AdListPlacement`). Two cells with the same
  /// poolIndex cannot show at once; the later one shows the house ad.
  final int poolIndex;

  /// Height of a [template] cell at [width]. The house ad and the AdMob and
  /// Yandex layouts all take exactly this box: the native layouts fill it,
  /// and their media view takes whatever height the text rows leave.
  ///
  /// - `small`: a 4:1 strip, the shape of a banner-like row.
  /// - `medium`: a 16:9 media block plus [AdMetrics.mediumChrome] for
  ///   the text rows and the CTA.
  static double heightOf(NativeAdTemplate template, double width) =>
      switch (template) {
        NativeAdTemplate.small => width / 4,
        NativeAdTemplate.medium => width * 9 / 16 + AdMetrics.mediumChrome,
      };

  /// Maximum width of the ad cell.
  ///
  /// Both templates grow with the width, so at the full width of a tablet
  /// (~1000dp) the ad cell would be far taller than the content cards around
  /// it. 480 is a typical content column width; phones are not affected.
  static const double maxWidth = 480;

  @override
  State<NativeAdView> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAdView> {
  final AdsService? _ads = maybeAdsService();

  NativeAdController? _controller;

  @override
  void initState() {
    super.initState();
    final ads = _ads;
    if (ads != null && !ads.isReady) {
      // There is something to show only after init, and init does not go
      // through the controller, so rebuild by hand.
      ads.ready.whenComplete(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ads = _ads;
    if (ads == null) return;
    // The controller reads the scheme at load time, which is after this
    // synchronous attach, so it always has the theme colors.
    final controller = _controller ??= ads.nativeController(
      widget.slot,
      poolIndex: widget.poolIndex,
    );
    controller.updateTheme(Theme.of(context).colorScheme, context.l10n.adLabel);
    controller.attach(this);
  }

  @override
  void dispose() {
    _controller?.detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = _ads;
    final controller = _controller;
    if (ads == null || controller == null) return const SizedBox.shrink();

    // `canShowAds`: until [AdsService.init] finishes (or once ads are removed)
    // this cell takes no space in the list.
    return ListenableBuilder(
      listenable: ads.changes,
      builder: (context, _) {
        if (!ads.canShowAds) return const SizedBox.shrink();

        // LayoutBuilder, not MediaQuery: this cell sits in a list with
        // horizontal padding, so its real width is smaller than the screen.
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(
              0.0,
              NativeAdView.maxWidth,
            );
            final template = widget.slot.template;
            final height = NativeAdView.heightOf(template, width);
            return Center(
              child: SizedBox(
                height: height,
                width: width,
                child: SlotAdStack(
                  controller: controller,
                  owner: this,
                  houseAd: MoreAppHouseAd(height: height, template: template),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
