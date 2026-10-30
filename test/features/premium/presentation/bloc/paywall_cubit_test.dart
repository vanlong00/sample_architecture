import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:busmod/features/premium/data/models/subscription_plan.dart';
import 'package:busmod/features/premium/data/models/subscription_purchase_result.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_cubit.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockService extends Mock implements SubscriptionService {}

void main() {
  late MockService service;
  late StreamController<SubscriptionPurchaseResult> results;

  setUpAll(() => registerFallbackValue(SubscriptionPlan.monthly));

  setUp(() {
    service = MockService();
    results = StreamController<SubscriptionPurchaseResult>.broadcast();
    when(() => service.purchaseResultStream).thenAnswer((_) => results.stream);
    when(() => service.plans).thenReturn(const []);
    when(
      () => service.plansStatus,
    ).thenReturn(ValueNotifier(PlansStatus.ready));
    when(() => service.reloadPlans()).thenAnswer((_) async {});
    when(() => service.buy(any())).thenAnswer((_) async {});
    when(() => service.restore()).thenAnswer((_) async {});
  });

  tearDown(() => results.close());

  blocTest<PaywallCubit, PaywallState>(
    'startPlan then purchased',
    build: () => PaywallCubit(service),
    act: (c) async {
      await c.startPlan(SubscriptionPlan.monthly);
      results.add(const SubscriptionPurchaseResult.purchased());
    },
    wait: Duration.zero,
    expect: () => [
      const PaywallState.purchasing(),
      const PaywallState.purchased(),
    ],
    verify: (_) =>
        verify(() => service.buy(SubscriptionPlan.monthly)).called(1),
  );

  blocTest<PaywallCubit, PaywallState>(
    'canceled returns to idle, error carries message',
    build: () => PaywallCubit(service),
    act: (c) async {
      await c.startPlan(SubscriptionPlan.monthly);
      results.add(const SubscriptionPurchaseResult.canceled());
      await Future<void>.delayed(Duration.zero);
      await c.startPlan(SubscriptionPlan.monthly);
      results.add(const SubscriptionPurchaseResult.error('boom'));
    },
    wait: Duration.zero,
    expect: () => [
      const PaywallState.purchasing(),
      const PaywallState.idle(),
      const PaywallState.purchasing(),
      const PaywallState.error('boom'),
    ],
  );

  blocTest<PaywallCubit, PaywallState>(
    'buy throwing emits error instead of hanging',
    setUp: () => when(() => service.buy(any())).thenThrow(StateError('x')),
    build: () => PaywallCubit(service),
    act: (c) => c.startPlan(SubscriptionPlan.monthly),
    expect: () => [
      const PaywallState.purchasing(),
      const PaywallState.error('Purchase failed'),
    ],
  );

  blocTest<PaywallCubit, PaywallState>(
    'restore purchased and nothing to restore',
    build: () => PaywallCubit(service),
    act: (c) async {
      await c.restore();
      results.add(const SubscriptionPurchaseResult.restored());
      await Future<void>.delayed(Duration.zero);
      await c.restore();
      results.add(const SubscriptionPurchaseResult.nothingToRestore());
    },
    wait: Duration.zero,
    expect: () => [
      const PaywallState.restoring(),
      const PaywallState.restored(),
      const PaywallState.restoring(),
      const PaywallState.info('No purchases found'),
    ],
    verify: (_) => verify(() => service.restore()).called(2),
  );

  blocTest<PaywallCubit, PaywallState>(
    'restore failures are flagged fromRestore, purchase failures are not',
    setUp: () => when(() => service.restore()).thenThrow(StateError('x')),
    build: () => PaywallCubit(service),
    act: (c) async {
      await c.restore();
      results.add(const SubscriptionPurchaseResult.error('Store unavailable'));
      await Future<void>.delayed(Duration.zero);
      await c.startPlan(SubscriptionPlan.monthly);
      results.add(const SubscriptionPurchaseResult.error('Plan unavailable'));
    },
    wait: Duration.zero,
    expect: () => [
      const PaywallState.restoring(),
      const PaywallState.error('Restore failed', fromRestore: true),
      const PaywallState.error('Store unavailable'),
      const PaywallState.purchasing(),
      const PaywallState.error('Plan unavailable'),
    ],
  );

  blocTest<PaywallCubit, PaywallState>(
    'an error result while restoring is flagged fromRestore',
    build: () => PaywallCubit(service),
    act: (c) async {
      await c.restore();
      results.add(const SubscriptionPurchaseResult.error('Store unavailable'));
    },
    wait: Duration.zero,
    expect: () => [
      const PaywallState.restoring(),
      const PaywallState.error('Store unavailable', fromRestore: true),
    ],
  );

  test('reloadPlans delegates to the service', () async {
    final cubit = PaywallCubit(service);
    await cubit.reloadPlans();
    verify(() => service.reloadPlans()).called(1);
    await cubit.close();
  });
}
