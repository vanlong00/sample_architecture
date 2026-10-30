import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/services/cache_sync_service.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:busmod/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:busmod/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCache extends Mock implements CacheSyncService {}

class _MockAds extends Mock implements AdsService {}

class _MockSubs extends Mock implements SubscriptionService {}

void main() {
  late _MockCache cache;
  late _MockAds ads;
  late _MockSubs subs;

  setUp(() {
    cache = _MockCache();
    ads = _MockAds();
    subs = _MockSubs();
    when(() => cache.syncIfStale()).thenAnswer((_) async {});
    when(() => ads.init()).thenAnswer((_) async {});
    when(() => subs.initialize()).thenAnswer((_) async {});
  });

  SplashCubit build() => SplashCubit(
    cache,
    ads,
    subs,
    syncTimeout: const Duration(milliseconds: 20),
  );

  blocTest<SplashCubit, SplashState>(
    'emits loading then ready; ads and subs each called once',
    build: build,
    act: (c) => c.start(),
    expect: () => const [SplashState.loading(), SplashState.ready()],
    verify: (_) {
      verify(() => cache.syncIfStale()).called(1);
      verify(() => ads.init()).called(1);
      verify(() => subs.initialize()).called(1);
    },
  );

  test('ready is not emitted until cache sync completes', () async {
    final gate = Completer<void>();
    when(() => cache.syncIfStale()).thenAnswer((_) => gate.future);
    final cubit = build();
    final states = <SplashState>[];
    final sub = cubit.stream.listen(states.add);

    final started = cubit.start();
    await Future<void>.delayed(Duration.zero);
    expect(states, const [SplashState.loading()]);
    verifyNever(() => ads.init());

    gate.complete();
    await started;
    await Future<void>.delayed(Duration.zero);
    expect(states, const [SplashState.loading(), SplashState.ready()]);
    verifyInOrder([() => cache.syncIfStale(), () => subs.initialize()]);

    await sub.cancel();
    await cubit.close();
  });

  blocTest<SplashCubit, SplashState>(
    'throwing cache sync still ends in ready',
    setUp: () => when(() => cache.syncIfStale()).thenThrow(Exception('boom')),
    build: build,
    act: (c) => c.start(),
    expect: () => const [SplashState.loading(), SplashState.ready()],
    verify: (_) {
      verify(() => ads.init()).called(1);
      verify(() => subs.initialize()).called(1);
    },
  );

  test(
    'throwing ads/subs (async and sync) neither stop ready nor leak',
    () async {
      final uncaught = <Object>[];
      await runZonedGuarded(() async {
        when(() => ads.init()).thenAnswer((_) async => throw Exception('ads'));
        when(() => subs.initialize()).thenThrow(Exception('subs sync'));
        final cubit = build();
        await cubit.start();
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state, const SplashState.ready());
        await cubit.close();
      }, (e, _) => uncaught.add(e));
      expect(uncaught, isEmpty);
    },
  );

  blocTest<SplashCubit, SplashState>(
    'start twice syncs once',
    build: build,
    act: (c) async {
      await c.start();
      await c.start();
    },
    expect: () => const [SplashState.loading(), SplashState.ready()],
    verify: (_) {
      verify(() => cache.syncIfStale()).called(1);
      verify(() => ads.init()).called(1);
      verify(() => subs.initialize()).called(1);
    },
  );

  blocTest<SplashCubit, SplashState>(
    'ready even if ads.init never completes',
    setUp: () =>
        when(() => ads.init()).thenAnswer((_) => Completer<void>().future),
    build: build,
    act: (c) => c.start(),
    expect: () => const [SplashState.loading(), SplashState.ready()],
  );

  blocTest<SplashCubit, SplashState>(
    'ready after the sync timeout when the sync never completes',
    setUp: () => when(
      () => cache.syncIfStale(),
    ).thenAnswer((_) => Completer<void>().future),
    build: build,
    act: (c) => c.start(),
    wait: const Duration(milliseconds: 60),
    expect: () => const [SplashState.loading(), SplashState.ready()],
    verify: (_) {
      verify(() => ads.init()).called(1);
      verify(() => subs.initialize()).called(1);
    },
  );

  test('closing during sync does not emit or throw', () async {
    final gate = Completer<void>();
    when(() => cache.syncIfStale()).thenAnswer((_) => gate.future);
    final cubit = build();
    final started = cubit.start();
    await cubit.close();
    gate.complete();
    await started;
    expect(cubit.state, const SplashState.loading());
  });
}
