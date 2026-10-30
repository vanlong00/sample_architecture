import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/analytics/telemetry.dart';
import '../../../../core/storage/local_store.dart';

@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._store) : super(_load(_store));

  final LocalStore _store;
  static const _key = 'locale';

  static const _supported = {'en', 'vi'};

  /// The stored locale, else the device language when supported, else en.
  static Locale _load(LocalStore store) {
    String? stored;
    try {
      stored = store.read<String>(StoreBoxes.settings, _key);
    } catch (e, s) {
      // A bad stored value must not crash app start: fall back to the default.
      recordError(e, s, reason: 'LocaleCubit.load');
    }
    if (stored != null && _supported.contains(stored)) return Locale(stored);
    // Same object as PlatformDispatcher.instance in the app; overridable in tests.
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return Locale(_supported.contains(device) ? device : 'en');
  }

  void setLocale(Locale locale) {
    if (locale == state) return;
    unawaited(
      _store
          .write<String>(StoreBoxes.settings, _key, locale.languageCode)
          .catchError(
            (Object e, StackTrace s) =>
                recordError(e, s, reason: 'LocaleCubit.persist'),
          ),
    );
    emit(locale);
  }
}
