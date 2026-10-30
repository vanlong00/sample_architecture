import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/services/cache_sync_service.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/premium/data/models/subscription_plan.dart';
import 'package:busmod/features/premium/data/models/subscription_purchase_result.dart';
import 'package:busmod/features/premium/data/subscription_service.dart';
import 'package:flutter_test/flutter_test.dart' show Fake;
import 'package:fpdart/fpdart.dart';

import 'di_test_setup.dart';

/// Cards without media: no image fetch happens in widget tests.
const testCards = [
  ModCard(sourceId: 11, type: ModType.bus, title: 'Alpha Bus'),
  ModCard(sourceId: 12, type: ModType.bus, title: 'Beta Bus'),
];

class FakeModsRepository implements ModsRepository {
  @override
  Future<Either<Failure, ModPage>> list(
    ModQuery query, {
    required int skip,
    bool forceRefresh = false,
  }) async =>
      right((items: testCards, nextSkip: testCards.length, hasMore: false));

  @override
  Future<Either<Failure, ModPage>> search({
    required String query,
    ModType? type,
    required int skip,
    bool forceRefresh = false,
  }) async =>
      right((items: testCards, nextSkip: testCards.length, hasMore: false));

  @override
  Future<Either<Failure, ModDetail>> detail(int sourceId) async => right(
    ModDetail(sourceId: sourceId, type: ModType.bus, title: 'Detail $sourceId'),
  );

  @override
  Future<Either<Failure, List<ModCard>>> related(int sourceId) async =>
      right(const []);

  @override
  Future<Either<Failure, FilterOptions>> filterOptions(ModType type) async =>
      right((
        categories: const [],
        manufacturers: const [],
        countries: const [],
      ));
}

class FakeCacheSync extends Fake implements CacheSyncService {
  @override
  Future<void> syncIfStale() async {}
}

class FakeAdsService extends Fake implements AdsService {
  @override
  Future<void> init() async {}

  @override
  bool get listNativeAdsEnabled => false;

  @override
  Future<void> showInterstitialAd({
    InterstitialTrigger trigger = InterstitialTrigger.normal,
  }) async {}
}

class FakeSubscriptionService extends Fake implements SubscriptionService {
  @override
  Future<void> initialize() async {}

  @override
  bool get isPremium => false;

  @override
  Stream<bool> get entitlementStream => const Stream.empty();

  @override
  Stream<SubscriptionPurchaseResult> get purchaseResultStream =>
      const Stream.empty();

  @override
  List<SubscriptionPlanOption> get plans => const [];

  @override
  final ValueNotifier<PlansStatus> plansStatus = ValueNotifier(
    PlansStatus.unavailable,
  );

  @override
  Future<void> reloadPlans() async {}

  @override
  Future<void> restore() async {}
}

/// Real DI (Isar in a temp dir) with every network/platform-facing service
/// replaced by a fake, so a full `App` runs hermetically.
Future<Directory> setUpAppDi() async {
  final dir = await setUpDi();
  getIt.unregister<ModsRepository>();
  getIt.registerSingleton<ModsRepository>(FakeModsRepository());
  getIt.unregister<CacheSyncService>();
  getIt.registerSingleton<CacheSyncService>(FakeCacheSync());
  getIt.unregister<AdsService>();
  getIt.registerSingleton<AdsService>(FakeAdsService());
  getIt.unregister<SubscriptionService>();
  getIt.registerSingleton<SubscriptionService>(FakeSubscriptionService());
  return dir;
}
