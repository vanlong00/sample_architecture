import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/analytics/telemetry.dart';
import '../../../../core/storage/local_store.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._store) : super(_load(_store));

  final LocalStore _store;
  static const _key = 'themeMode';

  static ThemeMode _load(LocalStore store) {
    String? stored;
    try {
      stored = store.read<String>(StoreBoxes.settings, _key);
    } catch (e, s) {
      // A bad stored value must not crash app start: fall back to the default.
      recordError(e, s, reason: 'ThemeCubit.load');
    }
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggle() {
    setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    if (mode == state) return;
    unawaited(
      _store
          .write<String>(StoreBoxes.settings, _key, mode.name)
          .catchError(
            (Object e, StackTrace s) =>
                recordError(e, s, reason: 'ThemeCubit.persist'),
          ),
    );
    emit(mode);
  }
}
