import 'package:flutter/material.dart';

import '../controllers/ad_controller.dart';

/// Draws the ad of [controller] for [owner], or [houseAd] while there is
/// none. Shared by the native slots.
///
/// The ad sits in a [Stack] under the house ad, in a fixed first position, so
/// a staged ad (one that loads only while mounted) keeps the same element,
/// and the same platform view, when it turns into the loaded ad.
class SlotAdStack extends StatelessWidget {
  const SlotAdStack({
    required this.controller,
    required this.owner,
    required this.houseAd,
    super.key,
  });

  final AdController controller;
  final Object owner;
  final Widget houseAd;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // `isOwner`: one ad object must not sit in two platform views at once
        // (see [AdController]). A non-owner shows the house ad.
        if (!controller.isOwner(owner)) return houseAd;
        final loaded = controller.ad;
        final mounted = loaded ?? controller.staged;
        if (mounted == null) return houseAd;
        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Center(key: ValueKey(mounted), child: mounted.build()),
            ),
            if (loaded == null) houseAd,
          ],
        );
      },
    );
  }
}
