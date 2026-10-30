import 'dart:async';

import 'package:flutter/widgets.dart';

import '../ad_network.dart';
import '../ads_service.dart';
import 'slot_ad.dart';

/// Loads one ad of one network for a slot.
abstract interface class SlotAdLoader {
  /// Completes with the loaded ad, or `null` when the load failed (the
  /// loader logs why and releases what it created, except a staged ad).
  ///
  /// [stage] receives an ad that has to be mounted before it can finish
  /// loading (unused by the native loaders). [onClicked] fires when the user taps
  /// the loaded ad.
  Future<SlotAd?> load({
    required void Function(SlotAd ad) stage,
    required VoidCallback onClicked,
  });

  /// Releases whatever the loader keeps across loads.
  void dispose();
}

/// Shared base of `NativeAdController`. It keeps the
/// ad alive outside the widget lifecycle and decides which widget may attach
/// it to the tree. It does not know the ad network: [AdsService.network]
/// picks the [SlotAdLoader] on the first load.
///
/// The ad does not live in a widget's `State`: `MainNavPage` uses an
/// `AnimatedSwitcher`, so every tab switch unmounts the old tab. With the ad
/// in State, each tab switch would dispose it and send a new request; ten tab
/// switches would mean ten requests. The controller lives in `AdsService` (a
/// singleton), so the ad survives those mounts and unmounts.
///
/// ## Why an owner is needed
///
/// One ad object must not sit in two platform views at once. AdMob's
/// `AdWidget` throws `This AdWidget is already in the Widget tree` (the
/// plugin counts mounts by adId), and a Yandex native ad hands the same
/// native view to every platform view of its controller, which Android
/// rejects when the view already has a parent. This really happens: tapping
/// a pack in the SIMILAR section of a pack detail screen is a
/// `pushReplacement`, and during the route transition two `PackDetailPage`s
/// are alive and ask for the same slot.
///
/// So only the earliest widget to [attach] may display the ad. Later widgets
/// queue and show the house ad. When the current owner calls [detach],
/// ownership passes to the next one. By then the old platform view has left
/// the tree, so they do not collide.
abstract class AdController extends ChangeNotifier {
  AdController(this._ads);

  /// Maximum number of retries for one load.
  static const int maxRetries = 3;

  final AdsService _ads;
  SlotAdLoader? _loader;

  SlotAd? _ad;
  SlotAd? _staged;
  bool _isLoading = false;
  bool _isDisposed = false;

  int _retryCount = 0;
  Timer? _retryTimer;

  /// Owners in [attach] order. The first element is the current owner.
  final List<Object> _owners = <Object>[];

  /// The ad ready to display, or `null` if it has not loaded yet.
  SlotAd? get ad => _ad;

  /// An ad that is still loading but must already be mounted (see
  /// [SlotAdLoader.load]). The owner mounts it under the house ad.
  SlotAd? get staged => _staged;

  /// Whether [owner] is the widget allowed to attach [ad] to the tree.
  bool isOwner(Object owner) =>
      _owners.isNotEmpty && identical(_owners.first, owner);

  /// Called from `initState`. The first caller takes the display right and
  /// triggers the load. Later callers only queue.
  void attach(Object owner) {
    if (_isDisposed || _owners.contains(owner)) return;
    _owners.add(owner);
    if (_owners.length == 1) {
      onAcquired();
      _notifyLater();
    }
  }

  /// Called from `dispose`. Never disposes the ad: keeping it alive is the
  /// point of this controller.
  void detach(Object owner) {
    if (!_owners.remove(owner) || _isDisposed) return;
    // The new owner must rebuild. The widget that just left does not.
    if (_owners.isNotEmpty) _notifyLater();
  }

  /// The loader of [network], created on the first load.
  @protected
  SlotAdLoader createLoader(AdNetwork network);

  /// A new owner just appeared: decide whether to reuse the current ad or
  /// load a new one.
  @protected
  void onAcquired();

  /// A load just succeeded. Subclasses reset their refresh counters here.
  @protected
  void didLoad() {}

  /// The user tapped the current ad.
  @protected
  void onClicked() {}

  bool get isLoading => _isLoading;

  bool get isDisposed => _isDisposed;

  /// Starts a new load (cancels any pending retry).
  @protected
  void startLoad() {
    if (_isDisposed || _isLoading) return;
    _retryTimer?.cancel();
    _isLoading = true;
    unawaited(_load());
  }

  Future<void> _load() async {
    await _ads.ready;
    // Stays "loading" on purpose: with ads off there is nothing to retry.
    if (_isDisposed || !_ads.canShowAds) return;
    final loader = _loader ??= createLoader(_ads.network);
    final ad = await loader.load(stage: _stage, onClicked: onClicked);
    if (ad == null) {
      _onFailed();
    } else {
      _onLoaded(ad);
    }
  }

  void _stage(SlotAd ad) {
    if (_isDisposed) {
      ad.dispose();
      return;
    }
    _staged = ad;
    notifyListeners();
  }

  void _onLoaded(SlotAd ad) {
    _isLoading = false;
    _retryCount = 0;
    if (_isDisposed) {
      ad.dispose();
      return;
    }
    if (identical(_staged, ad)) _staged = null;
    final previous = _ad;
    _ad = ad;
    didLoad();
    notifyListeners();
    if (previous != null) _disposeNextFrame(previous);
  }

  void _onFailed() {
    _isLoading = false;
    final staged = _staged;
    _staged = null;
    if (staged != null) {
      notifyListeners();
      _disposeNextFrame(staged);
    }
    _scheduleRetry();
  }

  /// Right now the ad's platform view is still in the tree (the rebuild that
  /// drops it has not run yet), and disposing early kills it midway.
  void _disposeNextFrame(SlotAd ad) {
    WidgetsBinding.instance.addPostFrameCallback((_) => ad.dispose());
  }

  /// Retries with a backoff of 2s, 4s, then 8s.
  ///
  /// Required: the SDKs refresh an ad by themselves only after the first
  /// successful load. If the first load fails without a retry, the slot stays
  /// dead until the widget mounts again, and since the ad now lives outside
  /// the widget, that can be the rest of the session.
  void _scheduleRetry() {
    if (_isDisposed || _retryCount >= maxRetries) return;
    _retryCount++;
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(seconds: 1 << _retryCount), () {
      if (!_isDisposed && _owners.isNotEmpty) startLoad();
    });
  }

  /// [attach] and [detach] run in `initState` and `dispose`, in the middle of
  /// the build phase. Calling `notifyListeners` directly there throws
  /// "setState called during build", so it is deferred to the next microtask.
  void _notifyLater() {
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _retryTimer?.cancel();
    _ad?.dispose();
    _ad = null;
    _staged?.dispose();
    _staged = null;
    _loader?.dispose();
    _loader = null;
    _owners.clear();
    super.dispose();
  }
}
