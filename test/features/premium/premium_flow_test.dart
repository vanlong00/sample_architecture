// Real SubscriptionService + real PaywallCubit; only the Play store (mocked
// InAppPurchase) and AdsService are fake. Maps store outcomes to what the
// Paywall/Settings screens react to.
import 'dart:async';

import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/features/premium/data/models/subscription_plan.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_cubit.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:mocktail/mocktail.dart';

class _MockAds extends Mock implements AdsService {}

class _MockIap extends Mock implements InAppPurchase {}

PurchaseDetails _purchase(PurchaseStatus status) => PurchaseDetails(
  productID: 'pro_version',
  verificationData: PurchaseVerificationData(
    localVerificationData: '',
    serverVerificationData: '',
    source: 'google_play',
  ),
  transactionDate: null,
  status: status,
);

ProductDetailsResponse _monthly() => ProductDetailsResponse(
  productDetails: GooglePlayProductDetails.fromProductDetails(
    const ProductDetailsWrapper(
      description: 'd',
      name: 'n',
      productId: 'pro_version',
      productType: ProductType.subs,
      title: 't',
      subscriptionOfferDetails: [
        SubscriptionOfferDetailsWrapper(
          basePlanId: 'monthly',
          offerTags: [],
          offerIdToken: 'tok',
          pricingPhases: [
            PricingPhaseWrapper(
              billingCycleCount: 0,
              billingPeriod: 'P1M',
              formattedPrice: r'$3.99',
              priceAmountMicros: 3990000,
              priceCurrencyCode: 'USD',
              recurrenceMode: RecurrenceMode.infiniteRecurring,
            ),
          ],
        ),
      ],
    ),
  ),
  notFoundIDs: const [],
);

void main() {
  setUpAll(() {
    registerFallbackValue(_purchase(PurchaseStatus.pending));
    registerFallbackValue(
      PurchaseParam(
        productDetails: ProductDetails(
          id: 'x',
          title: 't',
          description: 'd',
          price: 'p',
          rawPrice: 0,
          currencyCode: 'USD',
        ),
      ),
    );
  });

  late _MockAds ads;
  late _MockIap iap;
  late StreamController<List<PurchaseDetails>> purchases;
  late SubscriptionService service;
  late PaywallCubit cubit;
  late List<PaywallState> states;
  late StreamSubscription<PaywallState> sub;

  setUp(() async {
    ads = _MockAds();
    iap = _MockIap();
    purchases = StreamController<List<PurchaseDetails>>.broadcast();
    when(() => ads.removeAds).thenReturn(false);
    when(() => ads.setRemoveAds(any())).thenAnswer((_) async {});
    when(() => ads.suppressNextAppOpen()).thenReturn(null);
    when(() => iap.purchaseStream).thenAnswer((_) => purchases.stream);
    when(() => iap.isAvailable()).thenAnswer((_) async => true);
    when(
      () => iap.queryProductDetails(any()),
    ).thenAnswer((_) async => _monthly());
    when(() => iap.restorePurchases()).thenAnswer((_) async {});
    when(() => iap.completePurchase(any())).thenAnswer((_) async {});
    service = SubscriptionService(ads, iap: iap, restoreTimeout: Duration.zero);
    await service.initialize();
    cubit = PaywallCubit(service);
    states = [];
    sub = cubit.stream.listen(states.add);
  });

  tearDown(() async {
    await sub.cancel();
    await cubit.close();
    await service.dispose();
    await purchases.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  test('billing flow that does not launch ends in error, never stuck on '
      'purchasing', () async {
    when(
      () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
    ).thenAnswer((_) async => false);

    await cubit.startPlan(SubscriptionPlan.monthly);
    await settle();

    expect(states.first, const PaywallState.purchasing());
    expect(states.last, isA<PaywallError>());
    expect(cubit.state, isNot(isA<PaywallPurchasing>()));
    expect(service.isPremium, isFalse);
  });

  test(
    'a paid purchase maps to purchased (not restored) and grants Pro',
    () async {
      when(
        () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).thenAnswer((_) async {
        purchases.add([_purchase(PurchaseStatus.purchased)]);
        return true;
      });

      await cubit.startPlan(SubscriptionPlan.monthly);
      await settle();

      expect(states, [
        const PaywallState.purchasing(),
        const PaywallState.purchased(),
      ]);
      expect(service.isPremium, isTrue);
      verify(() => ads.setRemoveAds(true)).called(1);
    },
  );

  test('a user restore that replays an active purchase maps to restored '
      '(not purchased)', () async {
    when(() => iap.restorePurchases()).thenAnswer((_) async {
      purchases.add([_purchase(PurchaseStatus.restored)]);
    });

    await cubit.restore();
    await settle();

    expect(states, [
      const PaywallState.restoring(),
      const PaywallState.restored(),
    ]);
    expect(service.isPremium, isTrue);
  });

  test(
    'a user restore with nothing replayed reports info and never revokes',
    () async {
      when(() => ads.removeAds).thenReturn(true);
      service = SubscriptionService(
        ads,
        iap: iap,
        restoreTimeout: Duration.zero,
      );
      await service.initialize(); // launch reconcile (silent store) keeps cache
      expect(service.isPremium, isTrue);
      final c = PaywallCubit(service);
      final seen = <PaywallState>[];
      final s = c.stream.listen(seen.add);

      await c.restore();
      await settle();

      expect(seen.last, isA<PaywallInfo>());
      expect(service.isPremium, isTrue);
      verifyNever(() => ads.setRemoveAds(false));
      await s.cancel();
      await c.close();
    },
  );
}
