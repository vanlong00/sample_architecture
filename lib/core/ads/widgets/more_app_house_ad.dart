import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../analytics/remote_config_service.dart';
import '../../analytics/telemetry.dart';
import '../../di/injector.dart';
import '../../l10n/l10n_ext.dart';
import '../ads_service.dart';
import '../more_app.dart';
import '../native_ad_template.dart';

/// House ad: promotes a "house" app, read from Remote Config.
///
/// It stands in for every slot state without a real ad (waiting for SDK
/// init, loading, load error, no-fill), so the slot is never empty and the
/// layout never jumps when the real ad arrives. It only reads Remote Config
/// and never touches the ads SDK.
///
/// Its shape follows the slot it replaces ([template]):
/// - small: a horizontal strip with a square icon, text, and a CTA.
/// - medium: a media block on top, then icon, name, and description, then a
///   full-width CTA.
///
/// The native ad factories (`MainActivity.kt`) draw the same two layouts for
/// AdMob and Yandex. Change both sides together. Draws nothing when ads are
/// removed or switched off.
class MoreAppHouseAd extends StatefulWidget {
  const MoreAppHouseAd({required this.height, this.template, super.key});

  /// Exactly the height the real ad slot will take.
  final double height;

  /// Template of the native slot being replaced. `null` means a strip
  /// (same layout as [NativeAdTemplate.small]).
  final NativeAdTemplate? template;

  bool get _isMedium => template == NativeAdTemplate.medium;

  @override
  State<MoreAppHouseAd> createState() => _MoreAppHouseAdState();
}

class _MoreAppHouseAdState extends State<MoreAppHouseAd> {
  /// Picked once: picking again in `build` would change the displayed app on
  /// every rebuild.
  late final MoreApp? _app = _pick();

  static MoreApp? _pick() {
    if (!getIt.isRegistered<RemoteConfigService>()) return null;
    final apps = getIt<RemoteConfigService>()
        .getMoreApps()
        .where((app) => app.storeUrl != null)
        .toList(growable: false);
    if (apps.isEmpty) return null;
    return apps[Random().nextInt(apps.length)];
  }

  static Future<void> _open(MoreApp app) async {
    try {
      await launchUrl(
        Uri.parse(app.storeUrl!),
        mode: LaunchMode.externalApplication,
      );
    } catch (error, stack) {
      recordError(error, stack, reason: 'house ad open store');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = _app;
    final ads = maybeAdsService();
    // No app to promote, or ads removed: give up the space entirely.
    if (app == null || (ads != null && !ads.adsAllowed)) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: InkWell(
          onTap: () => _open(app),
          child: Stack(
            children: [
              Positioned.fill(
                child: widget._isMedium
                    ? _MediumBody(app: app)
                    : _CompactBody(app: app, height: widget.height),
              ),
              const Positioned(top: 0, right: 0, child: _AdBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal strip: a square icon almost as tall as the cell, text in the
/// middle, and a CTA on the right.
class _CompactBody extends StatelessWidget {
  const _CompactBody({required this.app, required this.height});

  final MoreApp app;
  final double height;

  @override
  Widget build(BuildContext context) {
    final icon = (height - AdMetrics.gap * 2).clamp(
      0.0,
      AdMetrics.compactIconMax,
    );
    return Row(
      spacing: AdMetrics.gap,
      children: [
        _Icon(url: app.icon, size: icon),
        Expanded(child: _Text(app: app)),
        const _InstallButton(),
      ],
    );
  }
}

/// Vertical card for the medium template: the media fills the remaining
/// space, then the icon with text, then a full-width CTA.
class _MediumBody extends StatelessWidget {
  const _MediumBody({required this.app});

  final MoreApp app;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AdMetrics.gap,
      children: [
        Expanded(child: _Media(app: app)),
        Row(
          spacing: AdMetrics.gap,
          children: [
            _Icon(url: app.icon, size: AdMetrics.mediumIcon),
            Expanded(child: _Text(app: app, large: true, descriptionLines: 2)),
          ],
        ),
        const _InstallButton(expanded: true, large: true),
      ],
    );
  }
}

/// Media block of the medium cell: the banner image covers it. Without a
/// banner (or if it fails to load), an enlarged icon sits in the middle.
class _Media extends StatelessWidget {
  const _Media({required this.app});

  final MoreApp app;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AdMetrics.radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AdMetrics.radius),
        child: app.banner.isEmpty
            ? _fallback()
            : Image.network(
                app.banner,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() => Center(
    child: _Icon(url: app.icon, size: AdMetrics.mediumFallbackIcon),
  );
}

class _Icon extends StatelessWidget {
  const _Icon({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AdMetrics.radius),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: SizedBox(
          width: size,
          height: size,
          // A broken icon only leaves an empty cell: not worth an error.
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    required this.app,
    this.large = false,
    this.descriptionLines = 1,
  });

  final MoreApp app;

  /// Medium cell: the app name is the card's main line.
  final bool large;
  final int descriptionLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          app.name,
          style: (large ? text.titleMedium : text.labelLarge)?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          app.description,
          style: (large ? text.bodySmall : text.labelSmall)?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: descriptionLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// The "Ad" label in the top right corner, like the native ad layouts.
class _AdBadge extends StatelessWidget {
  const _AdBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AdMetrics.radius / 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AdMetrics.badgePaddingH,
          vertical: AdMetrics.badgePaddingV,
        ),
        child: Text(
          context.l10n.adLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onTertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InstallButton extends StatelessWidget {
  const _InstallButton({this.expanded = false, this.large = false});

  /// Medium cell: a full-width CTA.
  final bool expanded;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final label = Text(
      context.l10n.pbsuOpenStore,
      textAlign: TextAlign.center,
      style: (large ? text.titleMedium : text.labelSmall)?.copyWith(
        color: scheme.onPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AdMetrics.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AdMetrics.ctaPaddingH,
          vertical: AdMetrics.ctaPaddingV,
        ),
        child: expanded
            ? SizedBox(width: double.infinity, child: label)
            : label,
      ),
    );
  }
}
