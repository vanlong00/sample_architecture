import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/telemetry.dart';
import '../../data/models/subscription_plan.dart';
import '../../data/models/subscription_purchase_result.dart';
import '../../data/subscription_service.dart';
import 'paywall_state.dart';

// ponytail: no repository layer on purpose, the service is stream-based.
@injectable
class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit(this._service) : super(const PaywallState.idle()) {
    _resultSub = _service.purchaseResultStream.listen(_onResult);
  }

  final SubscriptionService _service;
  late final StreamSubscription<SubscriptionPurchaseResult> _resultSub;

  /// The plan the user last tapped, to attribute the purchase result.
  SubscriptionPlan? _pendingPlan;

  /// Available plans, resolved from the store at launch.
  List<SubscriptionPlanOption> get plans => _service.plans;

  /// Progress of the store query, for the "unavailable" message.
  ValueListenable<PlansStatus> get plansStatus => _service.plansStatus;

  Future<void> reloadPlans() => _service.reloadPlans();

  Future<void> startPlan(SubscriptionPlan plan) async {
    if (state is PaywallPurchasing) return;
    _pendingPlan = plan;
    logEvent('tap_subscribe', {'plan': plan.basePlanId});
    emit(const PaywallState.purchasing());
    try {
      await _service.buy(plan);
    } catch (e, s) {
      recordError(e, s, reason: 'PaywallCubit.startPlan');
      _fail('Purchase failed');
    }
  }

  Future<void> restore() async {
    if (state is PaywallRestoring) return;
    emit(const PaywallState.restoring());
    try {
      await _service.restore();
    } catch (e, s) {
      recordError(e, s, reason: 'PaywallCubit.restore');
      _fail('Restore failed', fromRestore: true);
    }
  }

  void _fail(String message, {bool fromRestore = false}) {
    if (isClosed) return;
    logEvent('purchase_failed', {
      'reason': message,
      if (_pendingPlan != null) 'plan': _pendingPlan!.basePlanId,
    });
    emit(PaywallState.error(message, fromRestore: fromRestore));
  }

  void _onResult(SubscriptionPurchaseResult result) {
    if (isClosed) return;
    switch (result) {
      case PurchaseSucceeded():
        // Only a user-driven buy has a pending plan; restores don't.
        final plan = _pendingPlan;
        _pendingPlan = null;
        if (plan != null) {
          logEvent('purchase_success', {'plan': plan.basePlanId});
        }
        emit(const PaywallState.purchased());
      case PurchaseRestored():
        emit(const PaywallState.restored());
      case PurchasePending():
        emit(const PaywallState.pending());
      case PurchaseCanceled():
        emit(const PaywallState.idle());
      case PurchaseFailed(:final message):
        // A restore in flight owns the error (e.g. 'Store unavailable').
        _fail(message, fromRestore: state is PaywallRestoring);
      case NothingToRestore():
        emit(const PaywallState.info('No purchases found'));
    }
  }

  @override
  Future<void> close() {
    _resultSub.cancel();
    return super.close();
  }
}
