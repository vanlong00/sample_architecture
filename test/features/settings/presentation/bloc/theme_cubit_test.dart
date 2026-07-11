import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/core/storage/hive_service.dart';
import 'package:sample_architecture/features/settings/presentation/bloc/theme_cubit.dart';

class MockHiveService extends Mock implements HiveService {}

void main() {
  late MockHiveService hive;

  setUp(() {
    hive = MockHiveService();
    when(() => hive.write<String>(any(), any(), any()))
        .thenAnswer((_) async {});
  });

  test('khởi tạo mặc định là system khi Hive rỗng', () {
    when(() => hive.read<String>(HiveBoxes.settings, 'themeMode'))
        .thenReturn(null);
    final cubit = ThemeCubit(hive);
    expect(cubit.state, ThemeMode.system);
  });

  blocTest<ThemeCubit, ThemeMode>(
    'toggle từ light sang dark và ghi Hive',
    build: () {
      when(() => hive.read<String>(HiveBoxes.settings, 'themeMode'))
          .thenReturn('light');
      return ThemeCubit(hive);
    },
    act: (c) => c.toggle(),
    expect: () => [ThemeMode.dark],
    verify: (_) {
      verify(() => hive.write<String>(HiveBoxes.settings, 'themeMode', 'dark'))
          .called(1);
    },
  );
}
