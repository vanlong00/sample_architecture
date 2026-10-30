import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:yandex_mobileads/mobile_ads.dart' as yandex;

/// A loaded interstitial or app-open ad of either network.
abstract interface class FullScreenAd {
  /// Shows the ad. Afterwards exactly one of [onDismissed] or [onFailed]
  /// runs; [onShown] runs first when the ad takes the screen.
  Future<void> show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailed,
  });

  void dispose();
}

/// Loads one full-screen ad. Completes with `null` on failure (logged).
typedef FullScreenAdLoader = Future<FullScreenAd?> Function();

/// One full-screen placement (app-open or interstitial): the ready ad and
/// when it loaded.
class FullScreenAdSlot {
  FullScreenAdSlot(this._loader, {this.now = DateTime.now});

  /// AdMob stops counting impressions for an ad older than this, and the
  /// same limit is kept for Yandex so both networks behave alike. Past it the
  /// ad is dropped and reloaded instead of shown.
  static const Duration maxAge = Duration(hours: 4);

  final FullScreenAdLoader _loader;

  /// Clock for the [maxAge] check, replaceable in tests.
  final DateTime Function() now;

  FullScreenAd? _ad;
  DateTime? _loadedAt;

  bool get isLoaded => _ad != null;

  /// Replaces the current ad with a freshly loaded one.
  Future<void> load() async {
    dispose();
    final ad = await _loader();
    if (ad == null) return;
    _ad?.dispose();
    _ad = ad;
    _loadedAt = now();
  }

  /// Hands over the ad when it is still fresh. Returns `null` when there is
  /// none or it expired (an expired ad is disposed). The slot no longer owns
  /// a returned ad.
  FullScreenAd? take() {
    final ad = _ad;
    final loadedAt = _loadedAt;
    if (ad == null || loadedAt == null) return null;
    if (now().difference(loadedAt) > maxAge) {
      dispose();
      return null;
    }
    _ad = null;
    _loadedAt = null;
    return ad;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
    _loadedAt = null;
  }
}

FullScreenAdLoader admobInterstitialLoader(
  String unitId,
  admob.AdRequest Function() request,
) => () {
  final done = Completer<FullScreenAd?>();
  admob.InterstitialAd.load(
    adUnitId: unitId,
    request: request(),
    adLoadCallback: admob.InterstitialAdLoadCallback(
      onAdLoaded: (ad) => done.complete(_AdmobInterstitialAd(ad)),
      onAdFailedToLoad: (error) {
        debugPrint('[Ads] interstitial load fail: ${error.message}');
        done.complete(null);
      },
    ),
  );
  return done.future;
};

FullScreenAdLoader admobAppOpenLoader(
  String unitId,
  admob.AdRequest Function() request,
) => () {
  final done = Completer<FullScreenAd?>();
  admob.AppOpenAd.load(
    adUnitId: unitId,
    request: request(),
    adLoadCallback: admob.AppOpenAdLoadCallback(
      onAdLoaded: (ad) => done.complete(_AdmobAppOpenAd(ad)),
      onAdFailedToLoad: (error) {
        debugPrint('[Ads] app-open load fail: ${error.message}');
        done.complete(null);
      },
    ),
  );
  return done.future;
};

/// Yandex loaders are created on first use: constructing one opens a native
/// channel, which only the Yandex path needs.
FullScreenAdLoader yandexInterstitialLoader(String unitId) {
  yandex.InterstitialAdLoader? loader;
  return () async {
    try {
      final ad = await (loader ??= yandex.InterstitialAdLoader()).loadAd(
        adRequest: yandex.AdRequest(adUnitId: unitId),
      );
      return _YandexInterstitialAd(ad);
    } on yandex.AdRequestError catch (error) {
      debugPrint('[Ads] yandex interstitial load fail: ${error.description}');
      return null;
    }
  };
}

FullScreenAdLoader yandexAppOpenLoader(String unitId) {
  yandex.AppOpenAdLoader? loader;
  return () async {
    try {
      final ad = await (loader ??= yandex.AppOpenAdLoader()).loadAd(
        adRequest: yandex.AdRequest(adUnitId: unitId),
      );
      return _YandexAppOpenAd(ad);
    } on yandex.AdRequestError catch (error) {
      debugPrint('[Ads] yandex app-open load fail: ${error.description}');
      return null;
    }
  };
}

final class _AdmobInterstitialAd implements FullScreenAd {
  _AdmobInterstitialAd(this._ad);

  final admob.InterstitialAd _ad;

  @override
  Future<void> show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailed,
  }) {
    _ad.fullScreenContentCallback = _admobCallback(
      onShown,
      onDismissed,
      onFailed,
    );
    return _ad.show();
  }

  @override
  void dispose() => _ad.dispose();
}

final class _AdmobAppOpenAd implements FullScreenAd {
  _AdmobAppOpenAd(this._ad);

  final admob.AppOpenAd _ad;

  @override
  Future<void> show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailed,
  }) {
    _ad.fullScreenContentCallback = _admobCallback(
      onShown,
      onDismissed,
      onFailed,
    );
    return _ad.show();
  }

  @override
  void dispose() => _ad.dispose();
}

admob.FullScreenContentCallback<T> _admobCallback<T extends admob.Ad>(
  VoidCallback onShown,
  VoidCallback onDismissed,
  void Function(String message) onFailed,
) => admob.FullScreenContentCallback<T>(
  onAdShowedFullScreenContent: (_) => onShown(),
  onAdDismissedFullScreenContent: (_) => onDismissed(),
  onAdFailedToShowFullScreenContent: (_, error) => onFailed(error.message),
);

final class _YandexInterstitialAd implements FullScreenAd {
  _YandexInterstitialAd(this._ad);

  final yandex.InterstitialAd _ad;

  @override
  Future<void> show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailed,
  }) async {
    await _ad.setAdEventListener(
      eventListener: yandex.InterstitialAdEventListener(
        onAdShown: onShown,
        onAdDismissed: onDismissed,
        onAdFailedToShow: (error) => onFailed(error.description),
      ),
    );
    await _ad.show();
  }

  @override
  void dispose() => _ad.destroy();
}

final class _YandexAppOpenAd implements FullScreenAd {
  _YandexAppOpenAd(this._ad);

  final yandex.AppOpenAd _ad;

  @override
  Future<void> show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailed,
  }) async {
    await _ad.setAdEventListener(
      eventListener: yandex.AppOpenAdEventListener(
        onAdShown: onShown,
        onAdDismissed: onDismissed,
        onAdFailedToShow: (error) => onFailed(error.description),
      ),
    );
    await _ad.show();
  }

  @override
  void dispose() => _ad.destroy();
}
