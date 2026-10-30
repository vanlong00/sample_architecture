import 'package:busmod/core/ads/ad_network.dart';
import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/analytics/remote_config_service.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/isar_test_setup.dart';

class _MockRemoteConfig extends Mock implements RemoteConfigService {}

class _MockLookup extends Mock implements AdCountryLookup {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;
  late _MockRemoteConfig config;
  late AdsService ads;

  setUp(() async {
    store = await openTestStore();
    config = _MockRemoteConfig();
    when(() => config.getBool(RemoteConfigKeys.adsEnabled)).thenReturn(true);
    when(
      () => config.getBool(RemoteConfigKeys.nativeListAdsEnabled),
    ).thenReturn(true);
    when(() => config.getInt(RemoteConfigKeys.maxAdRequests)).thenReturn(3);
    ads = AdsService(store, config, _MockLookup());
  });

  tearDown(() async {
    ads.dispose();
    await store.close(deleteFromDisk: true);
  });

  group('adsAllowed', () {
    for (final (removed, enabled, expected) in [
      (false, true, true),
      (true, true, false),
      (false, false, false),
      (true, false, false),
    ]) {
      test('removeAds=$removed ads_enabled=$enabled -> $expected', () async {
        when(
          () => config.getBool(RemoteConfigKeys.adsEnabled),
        ).thenReturn(enabled);
        await ads.setRemoveAds(removed);
        expect(ads.adsAllowed, expected);
      });
    }

    test('canShowAds is false before init even when allowed', () {
      expect(ads.adsAllowed, isTrue);
      expect(ads.canShowAds, isFalse);
    });
  });

  group('setRemoveAds', () {
    test('persists under settings/ads_remove', () async {
      expect(ads.removeAds, isFalse);
      await ads.setRemoveAds(true);
      expect(store.read<bool>(StoreBoxes.settings, 'ads_remove'), isTrue);
      expect(AdsService(store, config, _MockLookup()).removeAds, isTrue);
      await ads.setRemoveAds(false);
      expect(ads.removeAds, isFalse);
    });

    test('notifies listeners', () async {
      var calls = 0;
      ads.changes.addListener(() => calls++);
      await ads.setRemoveAds(true);
      expect(calls, 1);
    });

    test('disables native list ads gate and interstitial', () async {
      // listNativeAdsEnabled is the remote switch only; widgets also gate on
      // canShowAds, which requires adsAllowed.
      expect(ads.listNativeAdsEnabled, isTrue);
      await ads.setRemoveAds(true);
      expect(ads.canShowAds, isFalse);
      await ads.showInterstitialAd(); // no-op, must not throw or count
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isFalse);
    });
  });

  test('listNativeAdsEnabled follows remote config', () {
    when(
      () => config.getBool(RemoteConfigKeys.nativeListAdsEnabled),
    ).thenReturn(false);
    expect(ads.listNativeAdsEnabled, isFalse);
  });

  group('suppressNextAppOpen', () {
    test('consumed once by the next foreground event', () {
      expect(ads.consumeAppOpenSuppression(), isFalse);
      ads.suppressNextAppOpen();
      expect(ads.consumeAppOpenSuppression(), isTrue);
      expect(ads.consumeAppOpenSuppression(), isFalse);
    });

    test('expires after the window', () {
      var now = DateTime(2026);
      ads.clock = () => now;
      ads.suppressNextAppOpen();
      now = now
          .add(AdsService.appOpenSuppressWindow)
          .add(const Duration(seconds: 1));
      expect(ads.consumeAppOpenSuppression(), isFalse);
    });

    test('still valid just inside the window', () {
      var now = DateTime(2026);
      ads.clock = () => now;
      ads.suppressNextAppOpen();
      now = now.add(const Duration(seconds: 59));
      expect(ads.consumeAppOpenSuppression(), isTrue);
    });
  });

  group('interstitial counter (max_ad_requests = 3)', () {
    test('normal shows only on the 3rd request', () {
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isFalse);
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isFalse);
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isTrue);
      // not reset until an ad really shows
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isTrue);
    });

    test('now skips the counter', () {
      expect(ads.shouldShowInterstitial(InterstitialTrigger.now), isTrue);
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isFalse);
    });

    test('max_ad_requests = 1 shows every request', () {
      when(() => config.getInt(RemoteConfigKeys.maxAdRequests)).thenReturn(1);
      expect(ads.shouldShowInterstitial(InterstitialTrigger.normal), isTrue);
    });
  });

  test(
    'init never throws and completes ready (no platform channels)',
    () async {
      final lookup = _MockLookup();
      when(lookup.country).thenAnswer((_) async => 'RU');
      final svc = AdsService(store, config, lookup);
      await svc.init();
      expect(svc.isReady, isTrue);
      // SDK channels are missing in tests, so init failed softly.
      expect(svc.canShowAds, isFalse);
    },
  );
}
