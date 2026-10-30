import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:busmod/features/settings/presentation/bloc/locale_cubit.dart';

import '../../../../helpers/isar_test_setup.dart';

class _MockStore extends Mock implements LocalStore {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() async => store.close(deleteFromDisk: true));

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher
        .clearLocaleTestValue();
  });

  void deviceLocale(Locale l) =>
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue = l;

  test('restores the persisted locale over the device locale', () async {
    deviceLocale(const Locale('vi'));
    await store.write<String>(StoreBoxes.settings, 'locale', 'en');
    expect(LocaleCubit(store).state, const Locale('en'));
  });

  test('seeds from a supported device locale', () {
    deviceLocale(const Locale('vi', 'VN'));
    expect(LocaleCubit(store).state, const Locale('vi'));
  });

  test('unsupported device language falls back to en', () {
    deviceLocale(const Locale('fr', 'FR'));
    expect(LocaleCubit(store).state, const Locale('en'));
  });

  blocTest<LocaleCubit, Locale>(
    'setLocale emits and persists; same locale emits nothing',
    build: () => LocaleCubit(store),
    act: (c) => c
      ..setLocale(const Locale('en'))
      ..setLocale(const Locale('vi')),
    wait: const Duration(milliseconds: 200), // unawaited async write
    expect: () => [const Locale('vi')],
    verify: (_) =>
        expect(store.read<String>(StoreBoxes.settings, 'locale'), 'vi'),
  );

  test('a throwing store read falls back to the device locale', () {
    deviceLocale(const Locale('vi'));
    final failing = _MockStore();
    when(
      () => failing.read<String>(any(), any()),
    ).thenThrow(StateError('type mismatch'));
    expect(LocaleCubit(failing).state, const Locale('vi'));
  });

  test(
    'an unsupported stored locale falls back to the device locale',
    () async {
      deviceLocale(const Locale('en'));
      await store.write<String>(StoreBoxes.settings, 'locale', 'xx');
      expect(LocaleCubit(store).state, const Locale('en'));
    },
  );

  test('a failing store write is reported, not an unhandled error', () async {
    final failing = _MockStore();
    when(() => failing.read<String>(any(), any())).thenReturn(null);
    when(
      () => failing.write<String>(any(), any(), any()),
    ).thenAnswer((_) async => throw StateError('disk full'));
    final uncaught = <Object>[];
    await runZonedGuarded(() async {
      final c = LocaleCubit(failing);
      c.setLocale(const Locale('vi'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(c.state, isNotNull);
      await c.close();
    }, (e, _) => uncaught.add(e));
    expect(uncaught, isEmpty);
  });
}
