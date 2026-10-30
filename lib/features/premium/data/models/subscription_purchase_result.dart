import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_purchase_result.freezed.dart';

/// Outcome of a user-driven buy or restore, announced on
/// `SubscriptionService.purchaseResultStream`.
@freezed
sealed class SubscriptionPurchaseResult with _$SubscriptionPurchaseResult {
  const factory SubscriptionPurchaseResult.purchased() = PurchaseSucceeded;
  const factory SubscriptionPurchaseResult.restored() = PurchaseRestored;
  const factory SubscriptionPurchaseResult.pending() = PurchasePending;
  const factory SubscriptionPurchaseResult.canceled() = PurchaseCanceled;
  const factory SubscriptionPurchaseResult.error(String message) =
      PurchaseFailed;
  const factory SubscriptionPurchaseResult.nothingToRestore() =
      NothingToRestore;
}
