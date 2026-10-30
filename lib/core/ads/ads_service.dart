import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mobileads/mobile_ads.dart' as yandex;

import '../analytics/remote_config_service.dart';
import '../di/injector.dart';
import '../storage/local_store.dart';
import 'ad_list_placement.dart';
import 'ad_network.dart';
import 'ad_unit_ids.dart';
import 'controllers/native_ad_controller.dart';
import 'full_screen_ad.dart';

/// Returns the [AdsService] when DI has registered it, or `null` otherwise.
///
/// Widget tests build a page directly without running
/// `configureDependencies`, and `getIt<AdsService>()` would throw right in
/// `initState`. Missing infrastructure means no ads, not an error.
AdsService? maybeAdsService() =>
    getIt.isRegistered<AdsService>() ? getIt<AdsService>() : null;

/// How an interstitial request is counted for frequency capping.
enum InterstitialTrigger {
  /// Goes through the counter: only every `max_ad_requests`-th request really
  /// shows an ad. Used for repeated actions (screen opens, navigation).
  normal,

  /// Skips the counter and shows right away if an ad is ready. For rare,
  /// "worthwhile" actions where the user just got what they wanted and
  /// accepts an ad, for example a pack download.
  now,
}

/// Service that coordinates ads for the whole app: consent (UMP), then SDK
/// init, then keeping the interstitial ready (and the app-open ad, driven by the app foreground event).
///
/// One network serves every format for the whole run ([network]): Yandex in
/// [kYandexCountries], AdMob everywhere else. There is no fallback between
/// them. When the chosen SDK fails, native slots show the house ad and
/// full-screen ads do not show.
///
/// Native ads live in per-slot controllers ([nativeController]) so they
/// survive widget mounts. The service provides [adRequest], [canShowAds],
/// [adsAllowed], and [ready] to them.
@lazySingleton
class AdsService {
  AdsService(this._localStore, this._remoteConfig, this._countryLookup);

  /// Content rating cap sent with every AdMob request. Fixed: this app has no
  /// age gate.
  static final String maxAdContentRating = MaxAdContentRating.pg;

  final LocalStore _localStore;
  final RemoteConfigService _remoteConfig;
  final AdCountryLookup _countryLookup;

  /// "Remove ads purchased" flag. There is no IAP yet. This is the hook, so
  /// adding IAP only requires writing one key.
  static const String removeAdsKey = 'ads_remove';

  /// Whether the first app-open ad was skipped. See [showAppOpenAd].
  static const String firstAppOpenSkippedKey = 'ads_first_app_open_skipped';

  static const Duration _consentTimeout = Duration(seconds: 10);

  final Completer<void> _ready = Completer<void>();
  bool _initialized = false;
  bool _initializing = false;

  StreamSubscription<AppState>? _appStateSub;

  final Map<(NativeAdSlot, int), NativeAdController> _nativeControllers = {};

  AdNetwork _network = AdNetwork.admob;
  YandexUnits? _yandexUnits;

  /// The network decided in [init]. AdMob until then.
  AdNetwork get network => _network;

  /// Yandex units of this build. Non-null exactly when [network] is
  /// [AdNetwork.yandex].
  YandexUnits? get yandexUnits => _yandexUnits;

  // Created in [init], once the network is known.
  FullScreenAdSlot? _appOpen;
  FullScreenAdSlot? _interstitial;

  /// Shared by app-open and interstitial ads. Both take the full screen. If
  /// they overlap, the system swallows the second ad (lost impression) and
  /// the user gets interrupted twice.
  bool _isShowingFullScreenAd = false;

  /// The interstitial shows only on the [_maxAdRequests]-th request. Starts at
  /// 1 like the original: with `max_ad_requests = 3`, the ad shows on the 3rd
  /// request.
  int _numAdRequests = 1;
  int get _maxAdRequests =>
      _remoteConfig.getInt(RemoteConfigKeys.maxAdRequests);

  /// Completes when [init] finishes, **even when init fails**. Ad widgets
  /// `await` this before loading. Calling `load()` before the SDK finishes
  /// init sends the request without the `RequestConfiguration` (the content
  /// rating cap is lost: a policy violation, not only lost revenue).
  ///
  /// It must never hang: a failed init still completes. The widget only needs
  /// to know "done waiting". Whether it may show an ad is answered by
  /// [canShowAds].
  Future<void> get ready => _ready.future;

  /// Synchronous version of [ready]. Widgets use it to decide whether to
  /// register for a rebuild, not to decide whether to show an ad (that is
  /// [canShowAds]).
  bool get isReady => _ready.isCompleted;

  bool get removeAds {
    try {
      return _localStore.read<bool>(StoreBoxes.settings, removeAdsKey) ?? false;
    } catch (_) {
      // The store is not open (widget tests do not call LocalStore.init).
      // Treat it as not purchased.
      return false;
    }
  }

  /// Persists the flag and tells [changes] listeners (ad widgets) to rebuild.
  Future<void> setRemoveAds(bool value) async {
    await _localStore.write<bool>(StoreBoxes.settings, removeAdsKey, value);
    _changes.notify();
  }

  final _Changes _changes = _Changes();

  /// Fires after [setRemoveAds]. Ad widgets rebuild on it.
  Listenable get changes => _changes;

  /// Whether this app shows ads at all. Checks only the remove-ads flag and
  /// the Remote Config switch, not whether the SDK init has finished.
  ///
  /// Separate from [canShowAds] because widgets ask two different questions:
  /// "should I reserve room for an ad slot" (this one, answerable from the
  /// first frame, so a house ad can hold the slot while the SDK initializes)
  /// and "may I call `load()` yet" ([canShowAds]).
  bool get adsAllowed =>
      !removeAds && _remoteConfig.getBool(RemoteConfigKeys.adsEnabled);

  /// The single gate for "may the app load or show an ad".
  bool get canShowAds => _initialized && adsAllowed;

  /// Whether the native ad slots inside the pack list are on. A separate
  /// Remote Config switch, independent of [adsAllowed].
  ///
  /// Read through this service, not `getIt<RemoteConfigService>()` directly
  /// in the widget: widget tests build a page without running
  /// `configureDependencies`. There `maybeAdsService()` returns `null` and the
  /// list falls back to plain content instead of throwing.
  bool get listNativeAdsEnabled =>
      _remoteConfig.getBool(RemoteConfigKeys.nativeListAdsEnabled);

  /// Returns the controller for [slot], created once and then reused. So
  /// switching tabs or opening and closing a detail screen fires no extra
  /// request.
  ///
  /// [poolIndex] splits the ad slots in one list into several different ads.
  /// See [AdListPlacement.poolSize]. Defaults to 0 for places with only one
  /// slot.
  NativeAdController nativeController(NativeAdSlot slot, {int poolIndex = 0}) =>
      _nativeControllers.putIfAbsent((
        slot,
        poolIndex,
      ), () => NativeAdController(this, _remoteConfig, slot));

  /// Builds the AdMob request shared by every ad type.
  AdRequest adRequest() => const AdRequest();

  /// Runs once per app lifetime. A repeated call only returns [ready].
  ///
  /// The order is required: UMP consent, then SDK init. The country lookup
  /// runs in parallel with the consent step, since only SDK init needs its
  /// answer. Never throws.
  Future<void> init() async {
    if (_initialized || _initializing) return ready;
    _initializing = true;

    try {
      final country = _countryLookup.country();
      await _requestConsent();
      _decideNetwork(await country);
      switch (_network) {
        case AdNetwork.admob:
          await _initAdmob();
        case AdNetwork.yandex:
          await _initYandex();
      }
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('[Ads] init fail: $error\n$stackTrace');
    } finally {
      // Always complete: a widget that awaits `ready` must not hang because
      // init failed.
      if (!_ready.isCompleted) _ready.complete();
      _initializing = false;
    }

    if (!canShowAds) return;
    unawaited(loadAppOpenAd());
    unawaited(loadInterstitialAd());
    _startListeningAppState();
  }

  void _decideNetwork(String? country) {
    _network = networkFor(country);
    _yandexUnits = _network == AdNetwork.yandex
        ? YandexAdUnitIds.current
        : null;
    debugPrint('[Ads] network: ${_network.name} (country: $country)');

    final yandexUnits = _yandexUnits;
    if (yandexUnits == null) {
      _appOpen = FullScreenAdSlot(
        admobAppOpenLoader(AdUnitIds.appOpen, adRequest),
      );
      _interstitial = FullScreenAdSlot(
        admobInterstitialLoader(AdUnitIds.interstitial, adRequest),
      );
    } else {
      _appOpen = FullScreenAdSlot(yandexAppOpenLoader(yandexUnits.appOpen));
      _interstitial = FullScreenAdSlot(
        yandexInterstitialLoader(yandexUnits.interstitial),
      );
    }
  }

  Future<void> _initAdmob() async {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: maxAdContentRating,
        testDeviceIds: kDebugMode ? AdUnitIds.testDeviceIds : null,
      ),
    );
    await MobileAds.instance.initialize();
  }

  /// AdMob's `initialize()` is never called on this path: the Yandex run
  /// must not start a second SDK.
  Future<void> _initYandex() async {
    await yandex.YandexAds.initialize();
  }

  /// An error at any step is only logged, then the flow continues. With a
  /// broken UMP the app can still serve non-personalized ads. Blocking here
  /// would lose revenue over a network error.
  Future<void> _requestConsent() async {
    final params = ConsentRequestParameters(
      consentDebugSettings: kDebugMode
          ? ConsentDebugSettings(
              // Force the EEA region so the form always shows during
              // development tests.
              debugGeography: DebugGeography.debugGeographyEea,
              testIdentifiers: AdUnitIds.testDeviceIds,
            )
          : null,
    );

    final update = Completer<void>();
    // The plugin reports a missing channel or platform error as an unawaited
    // future error, which a plain try/catch misses and would hang `update`.
    runZonedGuarded(
      () => ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () {
          if (!update.isCompleted) update.complete();
        },
        (FormError error) {
          debugPrint('[Ads] consent info fail: ${error.message}');
          if (!update.isCompleted) update.complete();
        },
      ),
      (error, _) {
        debugPrint('[Ads] consent info throw: $error');
        if (!update.isCompleted) update.complete();
      },
    );
    await update.future.timeout(_consentTimeout, onTimeout: () {});

    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) debugPrint('[Ads] consent form: ${error.message}');
      });
    } catch (error) {
      debugPrint('[Ads] consent form throw: $error');
    }
  }

  Future<void> loadAppOpenAd() async {
    if (!canShowAds) return;
    await _appOpen?.load();
  }

  /// Returns `true` exactly once per install, and consumes that skip.
  ///
  /// A full-screen ad on the very first launch after install is a reason to
  /// uninstall. The flag lives in `LocalStore`, so the skip does not repeat
  /// in later sessions.
  @visibleForTesting
  Future<bool> consumeFirstAppOpenSkip() async {
    try {
      final skipped =
          _localStore.read<bool>(StoreBoxes.settings, firstAppOpenSkippedKey) ??
          false;
      if (skipped) return false;
      await _localStore.write<bool>(
        StoreBoxes.settings,
        firstAppOpenSkippedKey,
        true,
      );
      return true;
    } catch (_) {
      // No `LocalStore` (tests): do not block, show the ad.
      return false;
    }
  }

  /// How long a [suppressNextAppOpen] request stays valid.
  static const Duration appOpenSuppressWindow = Duration(seconds: 60);

  /// Clock for the suppress window. Tests replace it.
  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  DateTime? _suppressAppOpenUntil;

  /// Call right before the app deliberately leaves the foreground (Play
  /// Store, billing sheet, another app for Import). The next foreground event
  /// then skips the app-open ad, once. The request expires after
  /// [appOpenSuppressWindow] so it cannot swallow an unrelated later return.
  void suppressNextAppOpen() {
    _suppressAppOpenUntil = clock().add(appOpenSuppressWindow);
  }

  /// Returns `true` once per [suppressNextAppOpen] while it is still valid.
  @visibleForTesting
  bool consumeAppOpenSuppression() {
    final until = _suppressAppOpenUntil;
    _suppressAppOpenUntil = null;
    return until != null && clock().isBefore(until);
  }

  Future<void> showAppOpenAd() async {
    if (!canShowAds || _isShowingFullScreenAd) return;
    if (consumeAppOpenSuppression()) return;
    if (await consumeFirstAppOpenSkip()) return;
    final slot = _appOpen;
    if (slot != null) await _showFullScreen(slot);
  }

  Future<void> loadInterstitialAd() async {
    if (!canShowAds) return;
    await _interstitial?.load();
  }

  /// Returns `true` when this request may show an ad. For
  /// [InterstitialTrigger.normal] it increments the counter and returns
  /// `false` until the `max_ad_requests`-th request.
  @visibleForTesting
  bool shouldShowInterstitial(InterstitialTrigger trigger) {
    if (trigger == InterstitialTrigger.now) return true;
    if (_numAdRequests < _maxAdRequests) {
      _numAdRequests++;
      return false;
    }
    return true;
  }

  /// Called at "heavy" navigation points. Deliberately does not
  /// `await ready`: this responds to a tap, and waiting for init before
  /// showing a full-screen ad would hit the user after the target screen has
  /// already opened. The next tap will have an ad.
  ///
  /// [trigger] decides whether the frequency counter applies. See
  /// [InterstitialTrigger].
  Future<void> showInterstitialAd({
    InterstitialTrigger trigger = InterstitialTrigger.normal,
  }) async {
    if (!canShowAds || _isShowingFullScreenAd) return;
    if (!shouldShowInterstitial(trigger)) return;

    final slot = _interstitial;
    if (slot == null || !await _showFullScreen(slot)) return;
    // Reset even when this request is `now`: right after an ad, the next
    // `normal` request must count from the start, not show again at once.
    _numAdRequests = 1;
  }

  /// Shows the ad of [slot] if a fresh one is ready, and returns whether it
  /// tried to. A missing or expired ad starts a reload instead: the next
  /// request will have one.
  Future<bool> _showFullScreen(FullScreenAdSlot slot) async {
    final ad = slot.take();
    if (ad == null) {
      unawaited(slot.load());
      return false;
    }

    void finish() {
      _isShowingFullScreenAd = false;
      ad.dispose();
      // Ads may have been switched off while this one was on screen.
      if (canShowAds) unawaited(slot.load());
    }

    await ad.show(
      onShown: () => _isShowingFullScreenAd = true,
      onDismissed: finish,
      onFailed: (message) {
        debugPrint('[Ads] full-screen show fail: $message');
        finish();
      },
    );
    return true;
  }

  /// Uses [AppStateEventNotifier], not `WidgetsBindingObserver`: the observer
  /// also reports "background" when an interstitial takes the screen, so
  /// closing the interstitial would immediately show an app-open ad.
  ///
  /// It works on the Yandex path too, where AdMob is never initialized: the
  /// google_mobile_ads plugin creates its app-state notifier when the plugin
  /// attaches to the engine, not in `MobileAds.initialize()`.
  void _startListeningAppState() {
    if (_appStateSub != null) return;
    AppStateEventNotifier.startListening();
    _appStateSub = AppStateEventNotifier.appStateStream.listen((state) {
      if (state == AppState.foreground) unawaited(showAppOpenAd());
    });
  }

  @disposeMethod
  void dispose() {
    for (final controller in _nativeControllers.values) {
      controller.dispose();
    }
    _nativeControllers.clear();
    _appStateSub?.cancel();
    _appStateSub = null;
    _appOpen?.dispose();
    _interstitial?.dispose();
    _isShowingFullScreenAd = false;
    _numAdRequests = 1;
    _changes.dispose();
  }
}

class _Changes extends ChangeNotifier {
  void notify() => notifyListeners();
}
