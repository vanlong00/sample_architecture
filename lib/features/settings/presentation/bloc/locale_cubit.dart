import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';

@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._hive) : super(_load(_hive));

  final HiveService _hive;
  static const _key = 'locale';

  static Locale _load(HiveService hive) {
    try {
      final code = hive.read<String>(HiveBoxes.settings, _key) ?? 'en';
      return Locale(code);
    } catch (_) {
      // Box not open yet (e.g. before Hive init in tests) — use default.
      return const Locale('en');
    }
  }

  void setLocale(Locale locale) {
    _hive.write<String>(HiveBoxes.settings, _key, locale.languageCode);
    emit(locale);
  }
}
