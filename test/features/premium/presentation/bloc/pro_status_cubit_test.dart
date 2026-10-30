import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:busmod/features/premium/presentation/bloc/pro_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockService extends Mock implements SubscriptionService {}

void main() {
  late MockService service;
  late StreamController<bool> entitlement;

  setUp(() {
    service = MockService();
    entitlement = StreamController<bool>.broadcast();
    when(() => service.entitlementStream).thenAnswer((_) => entitlement.stream);
  });

  tearDown(() => entitlement.close());

  test('seeded from isPremium', () async {
    when(() => service.isPremium).thenReturn(true);
    final cubit = ProStatusCubit(service);
    expect(cubit.state, isTrue);
    await cubit.close();
  });

  blocTest<ProStatusCubit, bool>(
    'follows the entitlement stream and skips duplicates',
    setUp: () => when(() => service.isPremium).thenReturn(false),
    build: () => ProStatusCubit(service),
    act: (_) {
      entitlement
        ..add(false)
        ..add(true)
        ..add(true)
        ..add(false);
    },
    wait: Duration.zero,
    expect: () => [true, false],
  );
}
