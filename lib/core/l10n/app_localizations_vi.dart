// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Sample Architecture';

  @override
  String get retry => 'Thử lại';

  @override
  String get errorServer => 'Lỗi máy chủ. Vui lòng thử lại.';

  @override
  String get errorNetwork => 'Không có kết nối mạng.';

  @override
  String get errorCache => 'Lỗi dữ liệu cục bộ.';

  @override
  String get errorUnauthorized => 'Phiên đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errorUnknown => 'Đã có lỗi xảy ra.';
}
