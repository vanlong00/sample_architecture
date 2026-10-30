import 'dart:async';

import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/features/premium/data/models/subscription_plan.dart';
import 'package:busmod/features/premium/data/models/subscription_purchase_result.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:mocktail/mocktail.dart';

class MockAds extends Mock implements AdsService {}

class MockIap extends Mock implements InAppPurchase {}

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

ProductDetailsResponse _monthlyResponse() => ProductDetailsResponse(
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

  late MockAds ads;
  late MockIap iap;
  late StreamController<List<PurchaseDetails>> purchases;

  SubscriptionService build() =>
      SubscriptionService(ads, iap: iap, restoreTimeout: Duration.zero);

  setUp(() {
    ads = MockAds();
    iap = MockIap();
    purchases = StreamController<List<PurchaseDetails>>.broadcast();
    when(() => ads.removeAds).thenReturn(false);
    when(() => ads.setRemoveAds(any())).thenAnswer((_) async {});
    when(() => ads.suppressNextAppOpen()).thenReturn(null);
    when(() => iap.purchaseStream).thenAnswer((_) => purchases.stream);
    when(() => iap.isAvailable()).thenAnswer((_) async => true);
    when(() => iap.queryProductDetails(any())).thenAnswer(
      (_) async => ProductDetailsResponse(
        productDetails: const [],
        notFoundIDs: const [],
      ),
    );
    // The real plugin replays the active purchases (here none) as one list.
    when(() => iap.restorePurchases()).thenAnswer((_) async {
      purchases.add(const []);
    });
    when(() => iap.completePurchase(any())).thenAnswer((_) async {});
  });

  tearDown(() => purchases.close());

  test('grant sets removeAds true and emits entitlement', () async {
    final service = build();
    await service.initialize();
    final entitlement = expectLater(service.entitlementStream, emits(true));
    final result = expectLater(
      service.purchaseResultStream,
      emits(isA<PurchaseRestored>()),
    );
    // Not a launch reconcile any more: a user restore announces the grant.
    when(() => iap.restorePurchases()).thenAnswer((_) async {
      purchases.add([_purchase(PurchaseStatus.restored)]);
    });
    await service.restore();
    await entitlement;
    await result;
    expect(service.isPremium, isTrue);
    verify(() => ads.setRemoveAds(true)).called(1);
    await service.dispose();
  });

  test('launch reconcile with no active purchase revokes premium', () async {
    when(() => ads.removeAds).thenReturn(true);
    final service = build();
    final entitlement = expectLater(service.entitlementStream, emits(false));
    await service.initialize();
    await entitlement;
    expect(service.isPremium, isFalse);
    verify(() => ads.setRemoveAds(false)).called(1);
    await service.dispose();
  });

  test('launch reconcile keeps premium when the store never answers', () async {
    when(() => ads.removeAds).thenReturn(true);
    when(() => iap.restorePurchases()).thenAnswer((_) async {});
    final service = build();
    await service.initialize();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(service.isPremium, isTrue);
    verifyNever(() => ads.setRemoveAds(any()));
    await service.dispose();
  });

  test('restore window starts after restorePurchases completes', () async {
    when(() => ads.removeAds).thenReturn(true);
    final gate = Completer<void>();
    when(() => iap.restorePurchases()).thenAnswer((_) async {
      purchases.add(const []);
      await gate.future;
    });
    final service = SubscriptionService(
      ads,
      iap: iap,
      restoreTimeout: const Duration(milliseconds: 10),
    );
    final init = service.initialize();
    // Far longer than the window, but the store call is still running.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(service.isPremium, isTrue);
    verifyNever(() => ads.setRemoveAds(any()));
    gate.complete();
    await init;
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(service.isPremium, isFalse); // empty replay + window elapsed
    await service.dispose();
  });

  test('a purchase after buy() emits purchased, not restored', () async {
    when(
      () => iap.queryProductDetails(any()),
    ).thenAnswer((_) async => _monthlyResponse());
    when(
      () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
    ).thenAnswer((_) async => true);
    final service = build();
    await service.initialize();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await service.buy(SubscriptionPlan.monthly);
    final result = expectLater(
      service.purchaseResultStream,
      emits(isA<PurchaseSucceeded>()),
    );
    purchases.add([_purchase(PurchaseStatus.purchased)]);
    await result;
    await service.dispose();
  });

  group('pending purchase', () {
    PurchaseDetails pendingPurchase() =>
        _purchase(PurchaseStatus.pending)..pendingCompletePurchase = true;

    setUp(() {
      when(
        () => iap.queryProductDetails(any()),
      ).thenAnswer((_) async => _monthlyResponse());
      when(
        () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).thenAnswer((_) async => true);
    });

    test('after buy() emits pending, no grant, not completed; then purchased '
        'grants removeAds, announces and completes', () async {
      final service = build();
      await service.initialize();
      await service.buy(SubscriptionPlan.monthly);
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);

      purchases.add([pendingPurchase()]);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(results, [isA<PurchasePending>()]);
      expect(service.isPremium, isFalse);
      verifyNever(() => ads.setRemoveAds(true));
      verifyNever(() => iap.completePurchase(any()));

      purchases.add([
        _purchase(PurchaseStatus.purchased)..pendingCompletePurchase = true,
      ]);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(results, [isA<PurchasePending>(), isA<PurchaseSucceeded>()]);
      expect(service.isPremium, isTrue);
      verify(() => ads.setRemoveAds(true)).called(1);
      verify(() => iap.completePurchase(any())).called(1);
      await sub.cancel();
      await service.dispose();
    });

    test('a pending purchase replayed at launch stays silent', () async {
      when(() => iap.restorePurchases()).thenAnswer((_) async {
        purchases.add([pendingPurchase()]);
      });
      final service = build();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      await service.initialize();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(results, isEmpty);
      verifyNever(() => iap.completePurchase(any()));
      await sub.cancel();
      await service.dispose();
    });
  });

  group('plans and buy', () {
    setUp(() {
      when(
        () => iap.queryProductDetails(any()),
      ).thenAnswer((_) async => _monthlyResponse());
    });

    test('plansStatus: ready with plans, unavailable when empty', () async {
      var service = build();
      expect(service.plansStatus.value, PlansStatus.loading);
      await service.initialize();
      expect(service.plansStatus.value, PlansStatus.ready);
      expect(service.plans, hasLength(1));
      await service.dispose();

      when(() => iap.queryProductDetails(any())).thenAnswer(
        (_) async => ProductDetailsResponse(
          productDetails: const [],
          notFoundIDs: const [],
        ),
      );
      service = build();
      await service.initialize();
      expect(service.plansStatus.value, PlansStatus.unavailable);
      await service.dispose();
    });

    test('reloadPlans recovers after a failed query', () async {
      when(
        () => iap.queryProductDetails(any()),
      ).thenThrow(StateError('offline'));
      final service = build();
      await service.initialize();
      expect(service.plansStatus.value, PlansStatus.unavailable);

      when(
        () => iap.queryProductDetails(any()),
      ).thenAnswer((_) async => _monthlyResponse());
      await service.reloadPlans();
      expect(service.plansStatus.value, PlansStatus.ready);
      expect(service.plans, hasLength(1));
      await service.dispose();
    });

    for (final failure in <String, Future<bool> Function(Invocation)>{
      'returns false': (_) async => false,
      'throws': (_) async => throw StateError('billing'),
    }.entries) {
      test('buy emits error when buyNonConsumable ${failure.key}', () async {
        when(
          () =>
              iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
        ).thenAnswer(failure.value);
        final service = build();
        await service.initialize();
        final result = expectLater(
          service.purchaseResultStream,
          emits(isA<PurchaseFailed>()),
        );
        await service.buy(SubscriptionPlan.monthly);
        await result;
        await service.dispose();
      });
    }

    test(
      'buy suppresses the next app-open ad and emits nothing on success',
      () async {
        when(
          () =>
              iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
        ).thenAnswer((_) async => true);
        final service = build();
        await service.initialize();
        final results = <SubscriptionPurchaseResult>[];
        final sub = service.purchaseResultStream.listen(results.add);
        await service.buy(SubscriptionPlan.monthly);
        await Future<void>.delayed(Duration.zero);
        verify(() => ads.suppressNextAppOpen()).called(1);
        expect(results, isEmpty);
        await sub.cancel();
        await service.dispose();
      },
    );
  });

  test('initialize does not throw when the store fails', () async {
    when(() => iap.isAvailable()).thenThrow(StateError('no play services'));
    final service = build();
    await service.initialize();
    expect(service.plans, isEmpty);
    await service.dispose();
  });

  test('initialize with unavailable store keeps cached entitlement', () async {
    when(() => ads.removeAds).thenReturn(true);
    when(() => iap.isAvailable()).thenAnswer((_) async => false);
    final service = build();
    await service.initialize();
    expect(service.isPremium, isTrue);
    verifyNever(() => iap.restorePurchases());
    verifyNever(() => ads.setRemoveAds(any()));
    await service.dispose();
  });

  test('restore with nothing emits nothingToRestore', () async {
    final service = build();
    await service.initialize();
    // Let the launch cycle settle first.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final result = expectLater(
      service.purchaseResultStream,
      emits(isA<NothingToRestore>()),
    );
    await service.restore();
    await result;
    expect(service.isPremium, isFalse);
    await service.dispose();
  });

  // These run on the widget tester's fake clock (t.pump(duration)).
  group('slow store', () {
    // restorePurchases never answers: hits the 5 s store timeout.
    void hangRestore() => when(
      () => iap.restorePurchases(),
    ).thenAnswer((_) => Completer<void>().future);

    SubscriptionService slowBuild() => SubscriptionService(
      ads,
      iap: iap,
      restoreTimeout: const Duration(seconds: 6),
    );

    testWidgets('restore timing out keeps plans ready and buying works', (
      t,
    ) async {
      when(
        () => iap.queryProductDetails(any()),
      ).thenAnswer((_) async => _monthlyResponse());
      when(
        () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).thenAnswer((_) async => true);
      hangRestore();
      final service = slowBuild();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      unawaited(service.initialize());
      await t.pump(const Duration(seconds: 6));
      expect(service.plansStatus.value, PlansStatus.ready);
      unawaited(service.buy(SubscriptionPlan.monthly));
      await t.pump();
      verify(
        () => iap.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
      ).called(1);
      expect(results, isEmpty); // no 'store unavailable' / purchase failed
      await t.runAsync(() async {
        await sub.cancel();
        await service.dispose();
      });
    });

    testWidgets('late launch replay stays silent but grants', (t) async {
      hangRestore();
      final service = slowBuild();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      unawaited(service.initialize());
      await t.pump(const Duration(seconds: 6)); // restore timed out
      purchases.add([_purchase(PurchaseStatus.restored)]);
      await t.pump(const Duration(seconds: 1));
      expect(service.isPremium, isTrue);
      expect(results, isEmpty);
      await t.runAsync(() async {
        await sub.cancel();
        await service.dispose();
      });
    });

    testWidgets('replay after the launch cycle settled stays silent', (
      t,
    ) async {
      when(() => iap.restorePurchases()).thenAnswer((_) async {});
      final service = slowBuild();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      unawaited(service.initialize());
      await t.pump(const Duration(seconds: 7)); // window elapsed, cycle settled
      purchases.add([_purchase(PurchaseStatus.restored)]);
      await t.pump(const Duration(seconds: 1));
      expect(service.isPremium, isTrue);
      expect(results, isEmpty);
      await t.runAsync(() async {
        await sub.cancel();
        await service.dispose();
      });
    });

    testWidgets('user restore settles at once when the store replied empty', (
      t,
    ) async {
      final service = slowBuild();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      unawaited(service.initialize());
      await t.pump(const Duration(seconds: 7)); // launch cycle settles
      unawaited(service.restore());
      await t.pump(const Duration(milliseconds: 100)); // far below 6 s
      expect(results, [const SubscriptionPurchaseResult.nothingToRestore()]);
      await t.pump(const Duration(seconds: 10)); // no second emission
      expect(results, hasLength(1));
      await t.runAsync(() async {
        await sub.cancel();
        await service.dispose();
      });
    });

    testWidgets('user restore with no reply still waits for the window', (
      t,
    ) async {
      when(() => iap.restorePurchases()).thenAnswer((_) async {});
      final service = slowBuild();
      final results = <SubscriptionPurchaseResult>[];
      final sub = service.purchaseResultStream.listen(results.add);
      unawaited(service.initialize());
      await t.pump(const Duration(seconds: 7));
      unawaited(service.restore());
      await t.pump(const Duration(seconds: 5));
      expect(results, isEmpty);
      await t.pump(const Duration(seconds: 2));
      expect(results, [const SubscriptionPurchaseResult.nothingToRestore()]);
      await t.runAsync(() async {
        await sub.cancel();
        await service.dispose();
      });
    });
  });

  test('buy without a store emits error', () async {
    when(() => iap.isAvailable()).thenAnswer((_) async => false);
    final service = build();
    await service.initialize();
    final result = expectLater(
      service.purchaseResultStream,
      emits(isA<PurchaseFailed>()),
    );
    await service.buy(SubscriptionPlan.monthly);
    await result;
    await service.dispose();
  });
}
