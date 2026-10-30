import 'package:busmod/core/ads/ad_list_placement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const p = AdListPlacement(firstSlot: 3, interval: 10, poolSize: 3);

  test('isAd: first slot then every interval+1 rows', () {
    final ads = [
      for (var i = 0; i < 30; i++)
        if (p.isAd(i)) i,
    ];
    expect(ads, [3, 14, 25]);
  });

  test('itemIndexOf subtracts the ads before the row', () {
    expect([for (var i = 0; i < 3; i++) p.itemIndexOf(i)], [0, 1, 2]);
    expect(p.itemIndexOf(4), 3); // row 3 is an ad
    expect(p.itemIndexOf(15), 13); // rows 3 and 14 are ads
  });

  test('rowCount and itemIndexOf cover every item exactly once', () {
    for (final count in [0, 1, 3, 4, 13, 14, 15, 30]) {
      final rows = p.rowCount(count);
      final seen = [
        for (var i = 0; i < rows; i++)
          if (!p.isAd(i)) p.itemIndexOf(i),
      ];
      expect(seen, [for (var i = 0; i < count; i++) i], reason: '$count');
      if (rows > 0) expect(p.isAd(rows - 1), isFalse, reason: 'last row');
    }
  });

  test('poolIndexOf rotates', () {
    expect([3, 14, 25, 36].map(p.poolIndexOf), [0, 1, 2, 0]);
  });

  test('disabled is the identity mapping', () {
    const off = AdListPlacement(enabled: false);
    expect(off.rowCount(20), 20);
    expect(off.isAd(3), isFalse);
    expect(off.itemIndexOf(7), 7);
  });
}
