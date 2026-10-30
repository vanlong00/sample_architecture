import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/ads/ads_service.dart';
import '../../../../core/analytics/telemetry.dart';
import '../../../../core/services/cache_sync_service.dart';
import '../../../premium/data/subscription_service.dart';
import 'splash_state.dart';

/// Boot sequence. Never fails; only the cache sync gates `ready`. Ads (UMP
/// consent can wait on the user) and subscription run in the background.
@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._cache,
    this._ads,
    this._subs, {
    @ignoreParam this._syncTimeout = const Duration(seconds: 4),
  }) : super(const SplashState.initial());

  final CacheSyncService _cache;
  final AdsService _ads;
  final SubscriptionService _subs;

  /// Caps the cache sync: a cold start on a bad network must not sit on the
  /// splash for the full dio timeouts. The sync keeps running in background.
  final Duration _syncTimeout;

  Future<void> start() async {
    if (state is! SplashInitial) return;
    emit(const SplashState.loading());

    try {
      await _cache.syncIfStale().timeout(_syncTimeout, onTimeout: () {});
    } catch (error, stack) {
      recordError(error, stack, reason: 'SplashCubit.syncIfStale');
    }

    _background(_subs.initialize, 'SplashCubit.subscription');
    _background(_ads.init, 'SplashCubit.ads');

    if (!isClosed) emit(const SplashState.ready());
  }

  /// Future.sync also catches a synchronous throw from [task].
  void _background(Future<void> Function() task, String reason) {
    unawaited(
      Future.sync(task).catchError((Object error, StackTrace stack) {
        recordError(error, stack, reason: reason);
      }),
    );
  }
}
