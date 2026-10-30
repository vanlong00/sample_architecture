import 'package:busmod/features/mods/data/models/filter_option.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> cardJson({Map<String, dynamic>? download}) => {
  'sourceId': 7,
  'type': 'bus',
  'title': 'Volvo 9700',
  'media': {
    'thumbnail': 'https://cdn/t.jpg',
    'images': ['a', 'b'],
  },
  'download':
      download ??
      {
        'url': 'https://mediafire.com/secret',
        'storageUrl': 'https://cdn/7.zip',
        'sizeBytes': 100,
        'fileFormat': 'zip',
      },
  'manufacturer': {'_id': 'volvo', 'name': 'Volvo'},
  'category': {'_id': 'bus:articulated', 'name': 'Articulated'},
  'country': {'_id': 'se', 'name': 'Sweden'},
  'stats': {'downloads': 5},
};

void main() {
  group('ModCard', () {
    test('parses full card', () {
      final c = ModCard.fromJson(cardJson());
      expect(c.sourceId, 7);
      expect(c.type, ModType.bus);
      expect(c.manufacturer!.id, 'volvo');
      expect(c.category!.name, 'Articulated');
      expect(c.stats!.downloads, 5);
      expect(c.media!.images, ['a', 'b']);
      expect(c.thumbnail, 'https://cdn/t.jpg');
      expect(c.isDownloadable, isTrue);
    });

    test('ModDownload ignores url key: no trace after round trip', () {
      final c = ModCard.fromJson(cardJson());
      expect(c.download!.storageUrl, 'https://cdn/7.zip');
      expect(c.download!.toJson().containsKey('url'), isFalse);
      expect(c.toString().contains('mediafire'), isFalse);
      expect(c.toJson().toString().contains('mediafire'), isFalse);
    });

    test('minimal card: nullable fields null, images default empty', () {
      final c = ModCard.fromJson({'sourceId': 1, 'type': 'map', 'title': 'x'});
      expect(c.type, ModType.map);
      expect(c.media, isNull);
      expect(c.download, isNull);
      expect(c.thumbnail, isNull);
      expect(c.isDownloadable, isFalse);
      expect(ModMedia.fromJson(const {}).images, isEmpty);
    });

    test('isDownloadable false for null / empty storageUrl', () {
      expect(
        ModCard.fromJson(
          cardJson(download: {'storageUrl': null}),
        ).isDownloadable,
        isFalse,
      );
      expect(
        ModCard.fromJson(cardJson(download: {'storageUrl': ''})).isDownloadable,
        isFalse,
      );
    });

    test('isDownloadable needs a safe file extension (same as download)', () {
      for (final url in [
        'https://cdn/file',
        'https://cdn/a.z!p',
        'https://cdn/',
      ]) {
        expect(
          ModCard.fromJson(
            cardJson(download: {'storageUrl': url}),
          ).isDownloadable,
          isFalse,
          reason: url,
        );
      }
    });

    test('isMirrored rejects bad scheme / blocked host / no host (F1)', () {
      for (final url in [
        'file:///sdcard/a.zip',
        'ftp://cdn.x/a.zip',
        'https://www.mediafire.com/file/a.zip',
        'https://f000.backblazeb2.com/file/a.zip',
        'https://backblaze.com/a.zip',
        'https://evil.com@www.mediafire.com/a.zip',
        'https://MEDIAFIRE.com./a.zip',
        'https:///a.zip',
        '/files/a.zip',
        'a.zip',
        'javascript:alert(1)//a.zip',
      ]) {
        expect(
          ModCard.fromJson(
            cardJson(download: {'storageUrl': url}),
          ).isDownloadable,
          isFalse,
          reason: url,
        );
      }
      expect(
        ModCard.fromJson(
          cardJson(download: {'storageUrl': 'https://cdn.x/7.zip'}),
        ).isDownloadable,
        isTrue,
      );
    });

    test('all type values parse', () {
      for (final t in ModType.values) {
        final c = ModCard.fromJson({
          'sourceId': 1,
          'type': t.apiValue,
          'title': 'x',
        });
        expect(c.type, t);
      }
    });
  });

  group('ModDetail', () {
    test('parses specs + contentHtml, defaults', () {
      final d = ModDetail.fromJson({
        ...cardJson(),
        'contentHtml': '<p>hi</p>',
        'specs': [
          {'group': 'Engine', 'label': 'Power', 'value': '300'},
        ],
      });
      expect(d.contentHtml, '<p>hi</p>');
      expect(d.specs.single.label, 'Power');
      expect(d.isDownloadable, isTrue);
      final min = ModDetail.fromJson({
        'sourceId': 1,
        'type': 'car',
        'title': 'x',
      });
      expect(min.specs, isEmpty);
      expect(min.isDownloadable, isFalse);
    });

    test('groupSpecs keeps first-seen group order', () {
      ModSpec s(String g, String l) => ModSpec(group: g, label: l, value: 'v');
      final out = groupSpecs([s('B', '1'), s('A', '2'), s('B', '3')]);
      expect(out.map((e) => e.$1), ['B', 'A']);
      expect(out[0].$2.map((e) => e.label), ['1', '3']);
      expect(groupSpecs(const []), isEmpty);
    });
  });

  group('FilterOption', () {
    test('parses and countFor', () {
      final f = FilterOption.fromJson({
        '_id': 'volvo',
        'name': 'Volvo',
        'modCount': {'bus': 4, 'truck': 1},
      });
      expect(f.id, 'volvo');
      expect(f.countFor(ModType.bus), 4);
      expect(f.countFor(ModType.car), 0);
      expect(
        FilterOption.fromJson({'_id': 'x', 'name': 'X'}).countFor(ModType.bus),
        0,
      );
    });
  });
}
