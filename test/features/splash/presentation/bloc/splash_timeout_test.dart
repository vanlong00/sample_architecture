// The production default (4 s) is what bounds a cold start on a bad network;
// the other splash tests shrink it. Uses the widget-test fake clock.
import 'dart:async';

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
  testWidgets('a sync that never answers reaches ready after exactly 4 s', (
    t,
  ) async {
    final cache = _MockCache();
    final ads = _MockAds();
    final subs = _MockSubs();
    when(() => cache.syncIfStale()).thenAnswer((_) => Completer<void>().future);
    when(() => ads.init()).thenAnswer((_) async {});
    when(() => subs.initialize()).thenAnswer((_) async {});
    final cubit = SplashCubit(cache, ads, subs); // default timeout

    unawaited(cubit.start());
    await t.pump(const Duration(milliseconds: 3999));
    expect(cubit.state, const SplashState.loading());
    verifyNever(() => ads.init());

    await t.pump(const Duration(milliseconds: 2));
    expect(cubit.state, const SplashState.ready());
    verify(() => ads.init()).called(1);
    verify(() => subs.initialize()).called(1);
    await cubit.close();
  });
}
