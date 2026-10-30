import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:injectable/injectable.dart';

import '../../../core/ads/ads_service.dart';
import '../../../core/analytics/telemetry.dart';
import 'models/subscription_plan.dart';
import 'models/subscription_purchase_result.dart';

/// Why a restore cycle was started. They settle differently when the store
/// replays no active purchase:
/// * [launch]: silent reconcile on app start; revokes premium only when the
///   store explicitly replayed an empty result (expiry, cancel, refund). When
///   the store did not answer in time the cached value is kept.
/// * [user]: the user tapped "Restore"; emits
///   [SubscriptionPurchaseResult.nothingToRestore]. Never revokes (a transient
///   empty reply must not punish a paying user mid-session).
enum _RestoreReason { launch, user }

/// Where the store query for [SubscriptionService.plans] stands.
enum PlansStatus { loading, ready, unavailable }

/// Single source of truth for premium entitlement (Android / Google Play).
///
/// Entitlement is persisted through [AdsService.setRemoveAds] (LocalStore key
/// `ads_remove`): that gives an instant, offline-safe value at launch, and a
/// launch-time restore reconciles it against the store. Client-only: purchase
/// data is trusted, not validated server-side.
@lazySingleton
class SubscriptionService {
  SubscriptionService(
    this._ads, {
    @ignoreParam InAppPurchase? iap,
    @ignoreParam this._restoreTimeout = const Duration(seconds: 6),
  }) : _iapOverride = iap;

  static const productId = SubscriptionPlan.productId;
  static const _storeTimeout = Duration(seconds: 5);

  static const _emptyPhase = PricingPhaseWrapper(
    billingCycleCount: 0,
    billingPeriod: '',
    formattedPrice: '',
    priceAmountMicros: 0,
    priceCurrencyCode: '',
    recurrenceMode: RecurrenceMode.nonRecurring,
  );

  final AdsService _ads;
  final InAppPurchase? _iapOverride;
  final Duration _restoreTimeout;

  // Resolved lazily: touching the platform instance throws where there is no
  // plugin (unit tests), and that must stay inside initialize()'s try/catch.
  InAppPurchase get _iap => _iapOverride ?? InAppPurchase.instance;

  final _entitlementController = StreamController<bool>.broadcast();
  final _resultController =
      StreamController<SubscriptionPurchaseResult>.broadcast();

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  Timer? _restoreTimer;
  _RestoreReason? _restoreReason; // non-null while a restore cycle is in flight
  bool _sawActiveThisCycle = false;
  // Becomes true on the first buy/restore tap. Until then (the launch
  // reconcile, however late the store replays) results are never announced.
  bool _userDriven = false;
  bool _replayAnswered = false; // the store replayed a list (maybe empty)
  final List<SubscriptionPlanOption> _plans = [];
  bool _storeAvailable = false;
  bool _isPremium = false;

  /// Progress of the plan query, for the paywall ("unavailable" + retry).
  final ValueNotifier<PlansStatus> plansStatus = ValueNotifier(
    PlansStatus.loading,
  );

  bool get isPremium => _isPremium;
  Stream<bool> get entitlementStream => _entitlementController.stream;
  Stream<SubscriptionPurchaseResult> get purchaseResultStream =>
      _resultController.stream;

  /// The available base plans, resolved from the store.
  List<SubscriptionPlanOption> get plans => List.unmodifiable(_plans);

  SubscriptionPlanOption? planFor(SubscriptionPlan plan) {
    for (final o in _plans) {
      if (o.plan == plan) return o;
    }
    return null;
  }

  /// Never throws. Returns once the restore cycle is started; with no store
  /// (emulator, no Play Services) it returns after the availability check.
  Future<void> initialize() async {
    // Instant, offline-safe seed. The launch reconcile below corrects it.
    _isPremium = _ads.removeAds;
    try {
      await _purchaseSub?.cancel();
      _purchaseSub = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (Object e, StackTrace s) =>
            recordError(e, s, reason: 'purchaseStream'),
      );
      await _loadPlans();
      if (!_storeAvailable) return; // keep the cached value
    } catch (e, s) {
      _storeAvailable = false;
      plansStatus.value = PlansStatus.unavailable;
      recordError(e, s, reason: 'SubscriptionService.initialize');
      return;
    }
    // Active subs replay on the purchase stream; the cycle settles after
    // restorePurchases() completes (see _runRestore). Its own try/catch: a slow
    // restore (cold Play Services) must not undo the plans _loadPlans resolved.
    _beginRestore(_RestoreReason.launch);
    try {
      await _runRestore();
    } catch (e, s) {
      recordError(e, s, reason: 'SubscriptionService.launchRestore');
    }
  }

  /// Re-queries the store for plans (paywall "Retry"). Never throws.
  Future<void> reloadPlans() async {
    try {
      await _loadPlans();
    } catch (e, s) {
      _storeAvailable = false;
      plansStatus.value = PlansStatus.unavailable;
      recordError(e, s, reason: 'SubscriptionService.reloadPlans');
    }
  }

  Future<void> _loadPlans() async {
    plansStatus.value = PlansStatus.loading;
    _storeAvailable = await _iap.isAvailable().timeout(_storeTimeout);
    if (!_storeAvailable) {
      plansStatus.value = PlansStatus.unavailable;
      return;
    }
    final response = await _iap
        .queryProductDetails({productId})
        .timeout(_storeTimeout);
    _plans
      ..clear()
      ..addAll(_mapPlans(response.productDetails));
    plansStatus.value = _plans.isEmpty
        ? PlansStatus.unavailable
        : PlansStatus.ready;
  }

  /// Maps the store's per-base-plan [GooglePlayProductDetails] to the known
  /// [SubscriptionPlan]s by base plan id. Unknown offers are skipped.
  List<SubscriptionPlanOption> _mapPlans(List<ProductDetails> details) {
    final options = <SubscriptionPlanOption>[];
    for (final d in details) {
      final offer = _offerOf(d);
      final plan = SubscriptionPlan.fromBasePlanId(offer?.basePlanId);
      if (offer == null || plan == null) continue;
      if (options.any((o) => o.plan == plan)) continue;

      final phases = offer.pricingPhases;
      // Recurring (post-trial) phase: first paid phase, else the last phase.
      final paid = phases.firstWhere(
        (p) => p.priceAmountMicros > 0,
        orElse: () => phases.isNotEmpty ? phases.last : _emptyPhase,
      );
      final free = phases.where((p) => p.priceAmountMicros == 0).firstOrNull;

      options.add(
        SubscriptionPlanOption(
          plan: plan,
          details: d,
          price: paid.formattedPrice,
          isFree: free != null,
          trialPeriod: free?.billingPeriod,
        ),
      );
    }
    return options;
  }

  SubscriptionOfferDetailsWrapper? _offerOf(ProductDetails d) {
    if (d is! GooglePlayProductDetails) return null;
    final index = d.subscriptionIndex;
    final offers = d.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) return null;
    return offers[index];
  }

  Future<void> buy(SubscriptionPlan plan) async {
    if (!_storeAvailable) {
      _resultController.add(
        const SubscriptionPurchaseResult.error('Store unavailable'),
      );
      return;
    }
    final option = planFor(plan);
    if (option == null) {
      _resultController.add(
        const SubscriptionPurchaseResult.error('Plan unavailable'),
      );
      recordError(
        StateError('Plan ${plan.basePlanId} not found for $productId'),
        StackTrace.current,
        reason: 'SubscriptionService.buy',
      );
      return;
    }
    // A user buy supersedes any in-flight silent launch reconcile, so the
    // resulting purchase is announced (not swallowed).
    _restoreTimer?.cancel();
    _restoreReason = null;
    _userDriven = true;
    final pd = option.details as GooglePlayProductDetails;
    // The billing sheet backgrounds the app: no app-open ad on the way back.
    _ads.suppressNextAppOpen();
    var launched = false;
    try {
      launched = await _iap.buyNonConsumable(
        purchaseParam: GooglePlayPurchaseParam(
          productDetails: pd,
          offerToken: pd.offerToken,
        ),
      );
    } catch (e, s) {
      recordError(e, s, reason: 'SubscriptionService.buyNonConsumable');
    }
    if (!launched) {
      _resultController.add(
        const SubscriptionPurchaseResult.error('Billing flow did not start'),
      );
    }
  }

  Future<void> restore() async {
    if (!_storeAvailable) {
      _resultController.add(
        const SubscriptionPurchaseResult.error('Store unavailable'),
      );
      return;
    }
    _beginRestore(_RestoreReason.user);
    await _runRestore();
  }

  /// Opens a restore cycle: clears the per-cycle flags. The settle timer is
  /// armed later, by [_runRestore], once the store call returned.
  void _beginRestore(_RestoreReason reason) {
    _restoreReason = reason;
    if (reason == _RestoreReason.user) _userDriven = true;
    _sawActiveThisCycle = false;
    _replayAnswered = false;
    _restoreTimer?.cancel();
  }

  /// Asks the store to replay purchases, then waits [_restoreTimeout] (counted
  /// from the call's completion, not its start) for the replay to land.
  Future<void> _runRestore() async {
    final reason = _restoreReason;
    try {
      await _iap.restorePurchases().timeout(_storeTimeout);
    } catch (_) {
      // Only close our own cycle: a newer one (user tap) may have replaced it.
      if (_restoreReason == reason) {
        _restoreTimer?.cancel();
        _restoreReason = null; // no verdict: keep the cached entitlement
      }
      rethrow;
    }
    if (_restoreReason != reason || reason == null) return; // superseded
    // The store already answered (maybe empty) while restorePurchases ran:
    // a user restore need not sit out the whole window.
    if (reason == _RestoreReason.user && _replayAnswered) {
      _settleRestore();
      return;
    }
    _restoreTimer?.cancel();
    _restoreTimer = Timer(_restoreTimeout, _settleRestore);
  }

  void _settleRestore() {
    final reason = _restoreReason;
    _restoreReason = null;
    if (_sawActiveThisCycle) return; // already granted
    switch (reason) {
      case _RestoreReason.launch:
        // Revoke only on an explicit empty replay (expired or cancelled). A
        // store that never answered must not cost a paying user their Pro.
        if (_isPremium && _replayAnswered) unawaited(_setPremium(false));
      case _RestoreReason.user:
        _resultController.add(
          const SubscriptionPurchaseResult.nothingToRestore(),
        );
      case null:
        break;
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    _replayAnswered = true;
    // Mark before the first await so a settle racing this list sees the grant.
    if (purchases.any(
      (p) =>
          p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored,
    )) {
      _sawActiveThisCycle = true;
    }
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grant(
            announce: _userDriven,
            restored: p.status == PurchaseStatus.restored,
          );
        case PurchaseStatus.error:
          // Android reports a user cancel as an error whose message is
          // "BillingResponse.userCanceled": treat it as a silent cancel.
          if (_isBillingResponse(p, BillingResponse.userCanceled)) {
            _resultController.add(const SubscriptionPurchaseResult.canceled());
          } else {
            _resultController.add(
              SubscriptionPurchaseResult.error(_friendlyPurchaseError(p)),
            );
            recordError(
              p.error ?? StateError('Purchase failed'),
              StackTrace.current,
              reason: 'SubscriptionService.purchase',
            );
          }
        case PurchaseStatus.canceled:
          _resultController.add(const SubscriptionPurchaseResult.canceled());
        case PurchaseStatus.pending:
          continue; // not done: do not grant or complete
      }
      if (p.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(p);
        } catch (e, s) {
          recordError(e, s, reason: 'SubscriptionService.completePurchase');
        }
      }
    }
  }

  /// On Android the plugin puts the real response in `error.message` as
  /// `"BillingResponse.<name>"`.
  bool _isBillingResponse(PurchaseDetails p, BillingResponse response) {
    final raw = p.error?.message ?? '';
    return raw == response.toString() || raw.endsWith('.${response.name}');
  }

  /// Short technical message for logs / fallback. The UI shows its own l10n
  /// text for [SubscriptionPurchaseResult.error].
  String _friendlyPurchaseError(PurchaseDetails p) {
    bool m(BillingResponse r) => _isBillingResponse(p, r);
    if (m(BillingResponse.itemAlreadyOwned)) {
      return 'You already own this subscription. Tap restore to activate it.';
    }
    if (m(BillingResponse.itemUnavailable)) {
      return 'This plan is not available right now.';
    }
    if (m(BillingResponse.billingUnavailable)) {
      return 'Google Play billing is unavailable. Update the Play Store and try again.';
    }
    if (m(BillingResponse.serviceUnavailable) ||
        m(BillingResponse.serviceDisconnected) ||
        m(BillingResponse.serviceTimeout)) {
      return 'Google Play is temporarily unavailable. Please try again shortly.';
    }
    if (m(BillingResponse.networkError)) {
      return 'Network error. Check your connection and try again.';
    }
    if (m(BillingResponse.featureNotSupported)) {
      return 'Subscriptions are not supported on this device.';
    }
    if (m(BillingResponse.developerError)) {
      return 'Something went wrong. Please try again later.';
    }
    return 'Purchase failed. Please try again.';
  }

  /// Grants premium. [announce] emits [SubscriptionPurchaseResult.purchased]
  /// for user-driven flows; the silent launch reconcile skips the paywall noise.
  Future<void> _grant({required bool announce, required bool restored}) async {
    _sawActiveThisCycle = true;
    _restoreTimer?.cancel();
    _restoreReason = null;
    if (!_isPremium) await _setPremium(true);
    if (announce) {
      _resultController.add(
        restored
            ? const SubscriptionPurchaseResult.restored()
            : const SubscriptionPurchaseResult.purchased(),
      );
    }
  }

  /// Updates the in-memory flag, persists it via [AdsService.setRemoveAds]
  /// (ads off when premium) and notifies [entitlementStream]. A persistence
  /// failure is reported but the session still reflects the entitlement.
  Future<void> _setPremium(bool value) async {
    _isPremium = value;
    try {
      await _ads.setRemoveAds(value);
    } catch (e, s) {
      recordError(e, s, reason: 'SubscriptionService.persist');
    }
    if (!_entitlementController.isClosed) _entitlementController.add(value);
  }

  Future<void> dispose() async {
    _restoreTimer?.cancel();
    await _purchaseSub?.cancel();
    await _entitlementController.close();
    await _resultController.close();
    plansStatus.dispose();
  }
}
