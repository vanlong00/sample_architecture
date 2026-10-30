import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:busmod/features/settings/presentation/bloc/theme_cubit.dart';

import '../../../../helpers/isar_test_setup.dart';

class _MockStore extends Mock implements LocalStore {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStore store;

  setUp(() async => store = await openTestStore());
  tearDown(() async => store.close(deleteFromDisk: true));

  test('defaults to system when the store is empty', () {
    expect(ThemeCubit(store).state, ThemeMode.system);
  });

  test('restores the persisted mode', () async {
    await store.write<String>(StoreBoxes.settings, 'themeMode', 'dark');
    expect(ThemeCubit(store).state, ThemeMode.dark);
  });

  blocTest<ThemeCubit, ThemeMode>(
    'toggle from light to dark persists',
    setUp: () => store.write<String>(StoreBoxes.settings, 'themeMode', 'light'),
    build: () => ThemeCubit(store),
    act: (c) => c.toggle(),
    wait: const Duration(milliseconds: 200), // unawaited async write
    expect: () => [ThemeMode.dark],
    verify: (_) =>
        expect(store.read<String>(StoreBoxes.settings, 'themeMode'), 'dark'),
  );

  blocTest<ThemeCubit, ThemeMode>(
    'setMode to the current mode emits nothing',
    build: () => ThemeCubit(store),
    act: (c) => c.setMode(ThemeMode.system),
    expect: () => <ThemeMode>[],
  );

  test('a throwing store read falls back to system', () {
    final failing = _MockStore();
    when(
      () => failing.read<String>(any(), any()),
    ).thenThrow(StateError('type mismatch'));
    expect(ThemeCubit(failing).state, ThemeMode.system);
  });

  test('a failing store write is reported, not an unhandled error', () async {
    final failing = _MockStore();
    when(() => failing.read<String>(any(), any())).thenReturn(null);
    when(
      () => failing.write<String>(any(), any(), any()),
    ).thenAnswer((_) async => throw StateError('disk full'));
    final uncaught = <Object>[];
    await runZonedGuarded(() async {
      final c = ThemeCubit(failing);
      c.setMode(ThemeMode.dark);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(c.state, isNotNull);
      await c.close();
    }, (e, _) => uncaught.add(e));
    expect(uncaught, isEmpty);
  });
}
