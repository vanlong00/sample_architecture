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
    final code = hive.read<String>(HiveBoxes.settings, _key) ?? 'en';
    return Locale(code);
  }

  void setLocale(Locale locale) {
    _hive.write<String>(HiveBoxes.settings, _key, locale.languageCode);
    emit(locale);
  }
}
