import 'package:busmod/core/error/exceptions.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/isar_test_setup.dart';

FavoriteRecord rec(int id, {int at = 1, String? thumb}) => FavoriteRecord(
  sourceId: id,
  title: 'Mod $id',
  thumbUrl: thumb,
  type: ModType.bus,
  savedAtMs: at,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;
  late FavoritesLocalDataSource ds;

  setUp(() async {
    store = await openTestStore();
    ds = FavoritesLocalDataSource(store);
  });
  tearDown(() async => store.close(deleteFromDisk: true));

  test('write/readAll/delete round trip, upsert by sourceId', () async {
    expect(ds.readAll(), isEmpty);
    await ds.write(rec(1, thumb: 'http://t/1.png'));
    await ds.write(rec(2));
    await ds.write(rec(1, at: 9, thumb: 'http://t/1.png'));
    final all = ds.readAll()..sort((a, b) => a.sourceId - b.sourceId);
    expect(all, [rec(1, at: 9, thumb: 'http://t/1.png'), rec(2)]);

    await ds.delete(1);
    expect(ds.readAll(), [rec(2)]);
  });

  test('corrupt entries are skipped', () async {
    await ds.write(rec(1));
    await store.write<String>(StoreBoxes.favorites, '2', 'not a map');
    await store.write<Map<String, dynamic>>(StoreBoxes.favorites, '3', {
      'sourceId': 3,
    });
    await store.write<Map<String, dynamic>>(StoreBoxes.favorites, '4', {
      'sourceId': 4,
      'title': 't',
      'type': 'nope',
      'savedAtMs': 1,
    });
    expect(ds.readAll(), [rec(1)]);
  });

  test('reopen keeps data', () async {
    await ds.write(rec(7));
    final dir = store.directory!;
    await store.close();
    await store.init(directory: dir);
    expect(ds.readAll(), [rec(7)]);
  });

  test('closed store throws CacheException', () async {
    await store.close();
    expect(ds.readAll, throwsA(isA<CacheException>()));
    expect(() => ds.write(rec(1)), throwsA(isA<CacheException>()));
    expect(() => ds.delete(1), throwsA(isA<CacheException>()));
  });
}
