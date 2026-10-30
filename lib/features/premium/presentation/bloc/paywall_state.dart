import 'package:freezed_annotation/freezed_annotation.dart';

part 'paywall_state.freezed.dart';

/// Paywall screen state only (entitlement lives in `SubscriptionService`).
@freezed
sealed class PaywallState with _$PaywallState {
  const factory PaywallState.idle() = PaywallIdle;
  const factory PaywallState.purchasing() = PaywallPurchasing;
  const factory PaywallState.restoring() = PaywallRestoring;

  /// Play is waiting on the payment method (cash, carrier billing...): not
  /// blocking, the user may subscribe or restore again.
  const factory PaywallState.pending() = PaywallPending;
  const factory PaywallState.purchased() = PaywallPurchased;
  const factory PaywallState.restored() = PaywallRestored;
  const factory PaywallState.error(
    String message, {
    // True when a restore (not a purchase) failed, for the right UI message.
    @Default(false) bool fromRestore,
  }) = PaywallError;
  const factory PaywallState.info(String message) = PaywallInfo;
}
