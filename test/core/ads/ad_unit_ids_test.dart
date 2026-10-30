import 'package:busmod/core/ads/ad_unit_ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AdMob ids are Google test units', () {
    for (final id in [
      AdUnitIds.banner,
      AdUnitIds.interstitial,
      AdUnitIds.native,
      AdUnitIds.appOpen,
    ]) {
      expect(id, contains('3940256099942544'));
    }
  });

  test('Yandex ids are demo units', () {
    final u = YandexAdUnitIds.current;
    for (final id in [u.banner, u.interstitial, u.native, u.appOpen]) {
      expect(id, startsWith('demo-'));
    }
  });
}
