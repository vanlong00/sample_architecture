import 'package:in_app_purchase/in_app_purchase.dart';

/// The selectable subscription plans, each backed by a Google Play base plan
/// under the single [productId] subscription product.
enum SubscriptionPlan {
  monthly('monthly');

  const SubscriptionPlan(this.basePlanId);

  /// Play Console subscription product id. PLACEHOLDER: the real id comes from
  /// Play Console. This and the base plan ids below are the only place to change.
  static const productId = 'pro_version';

  /// Play Console base plan id this value maps to. PLACEHOLDER, see [productId].
  final String basePlanId;

  static SubscriptionPlan? fromBasePlanId(String? id) {
    for (final p in SubscriptionPlan.values) {
      if (p.basePlanId == id) return p;
    }
    return null;
  }
}

/// A [SubscriptionPlan] paired with its resolved store product and pricing.
///
/// [price] is the recurring (post-trial) price, not `details.price` (the first
/// phase, which reads "Free" when a trial exists). [isFree] / [trialPeriod]
/// describe the free phase, if any.
class SubscriptionPlanOption {
  const SubscriptionPlanOption({
    required this.plan,
    required this.details,
    required this.price,
    this.isFree = false,
    this.trialPeriod,
  });

  final SubscriptionPlan plan;
  final ProductDetails details;

  /// Recurring (post-trial) formatted price, e.g. "$3.99".
  final String price;

  /// True if the plan has a zero-price (free trial / intro) phase.
  final bool isFree;

  /// ISO-8601 billing period of the free phase, e.g. "P3D", or null.
  final String? trialPeriod;
}
