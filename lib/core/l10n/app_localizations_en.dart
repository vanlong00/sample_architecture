// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sample Architecture';

  @override
  String get retry => 'Retry';

  @override
  String get errorServer => 'Server error. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorCache => 'Local data error.';

  @override
  String get errorUnauthorized => 'Session expired. Please sign in again.';

  @override
  String get errorUnknown => 'Something went wrong.';
}
