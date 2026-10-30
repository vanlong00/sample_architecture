import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/storage/local_store.dart';

import '../../helpers/isar_test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() async => store.close(deleteFromDisk: true));

  test('write then read round-trips with types kept', () async {
    await store.write<String>(StoreBoxes.settings, 's', 'dark');
    await store.write<bool>(StoreBoxes.settings, 'b', true);
    await store.write<int>(StoreBoxes.settings, 'i', 7);
    await store.write<List<String>>(StoreBoxes.settings, 'l', ['a', 'b']);

    expect(store.read<String>(StoreBoxes.settings, 's'), 'dark');
    expect(store.read<bool>(StoreBoxes.settings, 'b'), isTrue);
    expect(store.read<int>(StoreBoxes.settings, 'i'), 7);
    expect(store.read<List<dynamic>>(StoreBoxes.settings, 'l'), ['a', 'b']);
    expect(store.read<String>(StoreBoxes.settings, 'missing'), isNull);
  });

  test('writing the same key overwrites', () async {
    await store.write<String>(StoreBoxes.favorites, 'a', '1');
    await store.write<String>(StoreBoxes.favorites, 'a', '2');
    expect(store.readAll(StoreBoxes.favorites), {'a': '2'});
  });

  test('same key in two boxes does not collide; readAll is per box', () async {
    await store.write<String>(StoreBoxes.favorites, 'm1', 'fav');
    await store.write<String>(StoreBoxes.modDownloads, 'm1', 'dl');
    await store.write<String>(StoreBoxes.modDownloads, 'm2', 'dl2');

    expect(store.read<String>(StoreBoxes.favorites, 'm1'), 'fav');
    expect(store.read<String>(StoreBoxes.modDownloads, 'm1'), 'dl');
    expect(store.readAll(StoreBoxes.modDownloads), {'m1': 'dl', 'm2': 'dl2'});
    expect(store.readAll(StoreBoxes.settings), isEmpty);
  });

  test('delete removes the key', () async {
    await store.write<String>(StoreBoxes.favorites, 'a', '1');
    await store.delete(StoreBoxes.favorites, 'a');
    expect(store.read<String>(StoreBoxes.favorites, 'a'), isNull);
  });

  test('data survives close and reopen on the same directory', () async {
    await store.write<String>(StoreBoxes.settings, 'k', 'v');
    final dir = store.directory!;
    await store.close();

    store = LocalStore();
    await store.init(directory: dir);
    expect(store.read<String>(StoreBoxes.settings, 'k'), 'v');
  });

  test('use before init throws StateError', () {
    expect(
      () => LocalStore().read<String>(StoreBoxes.settings, 'k'),
      throwsStateError,
    );
  });

  test('incompatible default.isar is deleted and reopened', () async {
    await store.close();
    final dir = await Directory.systemTemp.createTemp('busmod_store_corrupt');
    File('${dir.path}/default.isar').writeAsBytesSync([1, 2, 3, 4]);

    final recovered = LocalStore();
    await recovered.init(directory: dir.path);
    await recovered.write<String>(StoreBoxes.settings, 'k', 'v');
    expect(recovered.read<String>(StoreBoxes.settings, 'k'), 'v');
    await recovered.close(deleteFromDisk: true);
  });
}
