import 'package:flutter/material.dart';

/// Layout of a native ad cell, shared by the house ad and the native
/// factories of both networks (`MainActivity.kt`).
enum NativeAdTemplate {
  /// Horizontal strip: square icon, title and body, small CTA on the right.
  small,

  /// Media block on top, then icon with title and body, then a full-width
  /// CTA.
  medium,
}

/// Factory ids the native side registers. They must match the strings in
/// `MainActivity.kt`.
abstract final class NativeAdFactoryIds {
  static const String admob = 'busmodNativeAdmob';
  static const String yandex = 'busmodNativeYandex';
}

/// Sizes of the house ad / native cell, in logical px. Mirrored by the native
/// factories through [nativeAdOptions].
abstract final class AdMetrics {
  static const double gap = 8;
  static const double radius = 12;
  static const double ctaPaddingH = 12;
  static const double ctaPaddingV = 6;
  static const double compactIconMax = 64;
  static const double mediumIcon = 52;
  static const double mediumFallbackIcon = 88;
  static const double badgePaddingH = 6;
  static const double badgePaddingV = 1;
  static const double labelGap = 4;

  /// Height of a medium cell beyond its 16:9 media block (icon and text row,
  /// CTA, gaps, Yandex required labels).
  static const double mediumChrome = 128;
}

/// `customOptions` for the native factories: colors from [scheme], the l10n [adLabel], sizes from
/// [AdMetrics]. The native code only keeps fallbacks for a missing key.
///
/// Returns a fresh mutable map: `MyYandexNativeAdController` adds its ad unit
/// id to the map it receives.
Map<String, Object> nativeAdOptions(
  NativeAdTemplate template,
  ColorScheme scheme,
  String adLabel,
) {
  final medium = template == NativeAdTemplate.medium;
  return {
    'template': template.name,
    'adLabel': adLabel,
    'colors': <String, int>{
      'surface': scheme.surfaceContainerHigh.toARGB32(),
      'well': scheme.surfaceContainerHighest.toARGB32(),
      'border': scheme.outlineVariant.toARGB32(),
      'primary': scheme.primary.toARGB32(),
      'onPrimary': scheme.onPrimary.toARGB32(),
      'title': scheme.onSurface.toARGB32(),
      'muted': scheme.onSurfaceVariant.toARGB32(),
      'badge': scheme.tertiary.toARGB32(),
      'onBadge': scheme.onTertiary.toARGB32(),
    },
    'metrics': <String, double>{
      'gap': AdMetrics.gap,
      'radius': AdMetrics.radius,
      'ctaPaddingH': AdMetrics.ctaPaddingH,
      'ctaPaddingV': AdMetrics.ctaPaddingV,
      'badgePaddingH': AdMetrics.badgePaddingH,
      'badgePaddingV': AdMetrics.badgePaddingV,
      'compactIconMax': AdMetrics.compactIconMax,
      'mediumIcon': AdMetrics.mediumIcon,
      'labelGap': AdMetrics.labelGap,
    },
    'bodyLines': medium ? 2 : 1,
    'text': <String, Map<String, Object>>{
      'title': {'size': medium ? 16.0 : 14.0, 'bold': true},
      'body': {'size': medium ? 13.0 : 12.0, 'bold': false},
      'cta': {'size': medium ? 16.0 : 12.0, 'bold': true},
      'badge': {'size': 11.0, 'bold': true},
      // Yandex required labels (age, sponsored, domain, warning).
      'label': {'size': 10.0, 'bold': false},
    },
  };
}
