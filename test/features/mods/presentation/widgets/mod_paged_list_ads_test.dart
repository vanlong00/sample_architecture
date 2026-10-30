// US1/US9: native ads appear in Home lists only when ads are enabled and the
// user is not Pro, labelled with the localized adLabel.
import 'dart:async';

import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/ads/more_app.dart';
import 'package:busmod/core/ads/controllers/ad_controller.dart';
import 'package:busmod/core/ads/controllers/native_ad_controller.dart';
import 'package:busmod/core/ads/controllers/slot_ad.dart';
import 'package:busmod/core/analytics/remote_config_service.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_card_tile.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_paged_list.dart';
import 'package:busmod/core/ads/ad_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/isar_test_setup.dart';

class _MockConfig extends Mock implements RemoteConfigService {}

class _MockLookup extends Mock implements AdCountryLookup {}

/// Loader that never finishes: the slot keeps showing its house ad (which
/// carries the ad label) and no retry timer is left behind.
class _PendingLoader implements SlotAdLoader {
  @override
  Future<SlotAd?> load({
    required void Function(SlotAd ad) stage,
    required VoidCallback onClicked,
  }) => Completer<SlotAd?>().future;

  @override
  void dispose() {}
}

/// Real gating logic (flags + remote config); only SDK init is skipped.
class _TestAds extends AdsService {
  _TestAds(super.store, super.config, super.lookup, this._config);

  final RemoteConfigService _config;

  @override
  bool get canShowAds => adsAllowed; // as if init() had finished

  @override
  bool get isReady => true;

  @override
  Future<void> get ready => Future<void>.value();

  @override
  NativeAdController nativeController(NativeAdSlot slot, {int poolIndex = 0}) =>
      NativeAdController(
        this,
        _config,
        slot,
        loaderFor: (_) => _PendingLoader(),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;
  late _MockConfig config;
  late _TestAds ads;

  setUp(() async {
    store = await openTestStore();
    config = _MockConfig();
    when(() => config.getBool(RemoteConfigKeys.adsEnabled)).thenReturn(true);
    when(
      () => config.getBool(RemoteConfigKeys.nativeListAdsEnabled),
    ).thenReturn(true);
    when(() => config.getInt(any())).thenReturn(1);
    when(config.getMoreApps).thenReturn(const [
      MoreApp(name: 'Other app', description: 'desc', packageName: 'com.x.y'),
    ]);
    ads = _TestAds(store, config, _MockLookup(), config);
    getIt
      ..registerSingleton<RemoteConfigService>(config)
      ..registerSingleton<AdsService>(ads);
  });

  tearDown(() async {
    await getIt.reset();
    ads.dispose();
    await store.close(deleteFromDisk: true);
  });

  // Tall surface: ListView builds lazily and ad rows are medium-sized.
  void tall(WidgetTester t) {
    t.view.physicalSize = const Size(800, 6000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
  }

  Widget list(String locale) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(locale),
    home: Scaffold(
      body: ModPagedList(
        items: [
          for (var i = 0; i < 6; i++)
            ModCard(sourceId: i, type: ModType.bus, title: 'Mod $i'),
        ],
        hasMore: false,
        loadingMore: false,
        onLoadMore: () {},
        onRefresh: () async {},
        onTap: (_) {},
        adSlot: NativeAdSlot.modList,
      ),
    ),
  );

  testWidgets('ads enabled, not Pro: slot after 3 cards with the l10n label', (
    t,
  ) async {
    tall(t);
    await t.pumpWidget(list('en'));
    await t.pump();
    expect(find.text('Ad'), findsOneWidget);
    expect(find.byType(ModCardTile), findsWidgets);
    tall(t);
    await t.pumpWidget(list('vi'));
    await t.pump();
    expect(find.text('Quảng cáo'), findsOneWidget);
    expect(find.text('Ad'), findsNothing);
  });

  testWidgets('Pro (removeAds): no ad slot', (t) async {
    await t.runAsync(() => ads.setRemoveAds(true));
    tall(t);
    await t.pumpWidget(list('en'));
    await t.pump();
    expect(find.text('Ad'), findsNothing);
    expect(find.byType(ModCardTile), findsWidgets);
  });

  testWidgets('ads_enabled=false: no ad slot', (t) async {
    when(() => config.getBool(RemoteConfigKeys.adsEnabled)).thenReturn(false);
    tall(t);
    await t.pumpWidget(list('en'));
    await t.pump();
    expect(find.text('Ad'), findsNothing);
  });

  testWidgets('native_list_ads_enabled=false: no ad slot', (t) async {
    when(
      () => config.getBool(RemoteConfigKeys.nativeListAdsEnabled),
    ).thenReturn(false);
    tall(t);
    await t.pumpWidget(list('en'));
    await t.pump();
    expect(find.text('Ad'), findsNothing);
    expect(find.byType(ModCardTile), findsNWidgets(6));
  });
}
