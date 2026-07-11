import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._hive) : super(_load(_hive));

  final HiveService _hive;
  static const _key = 'themeMode';

  static ThemeMode _load(HiveService hive) {
    switch (hive.read<String>(HiveBoxes.settings, _key)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persist(next);
    emit(next);
  }

  void setMode(ThemeMode mode) {
    _persist(mode);
    emit(mode);
  }

  void _persist(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    _hive.write<String>(HiveBoxes.settings, _key, value);
  }
}
