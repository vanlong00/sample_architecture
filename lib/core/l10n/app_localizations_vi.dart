// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Busmod';

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

  @override
  String get errorModNotAvailable => 'Mod này không còn khả dụng';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navSearch => 'Tìm kiếm';

  @override
  String get navDownloaded => 'Đã tải';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get typeBus => 'Xe buýt';

  @override
  String get typeTruck => 'Xe tải';

  @override
  String get typeCar => 'Ô tô';

  @override
  String get typeMap => 'Bản đồ';

  @override
  String get sortPopular => 'Phổ biến';

  @override
  String get sortNewest => 'Mới nhất';

  @override
  String get filterTitle => 'Bộ lọc';

  @override
  String get filterBodyType => 'Kiểu thân xe';

  @override
  String get filterManufacturer => 'Hãng sản xuất';

  @override
  String get filterCountry => 'Quốc gia';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterApply => 'Áp dụng';

  @override
  String get filterReset => 'Đặt lại';

  @override
  String get searchHint => 'Tìm kiếm mod';

  @override
  String get searchAllTypes => 'Tất cả loại';

  @override
  String get searchEmpty => 'Không tìm thấy mod nào';

  @override
  String get listEmpty => 'Chưa có gì ở đây';

  @override
  String get detailSpecs => 'Thông số kỹ thuật';

  @override
  String get detailDescription => 'Mô tả';

  @override
  String detailMoreFrom(String name) {
    return 'Thêm từ $name';
  }

  @override
  String get detailMoreLike => 'Mod tương tự';

  @override
  String get ctaDownload => 'Tải xuống';

  @override
  String ctaDownloading(int percent) {
    return 'Đang tải $percent%';
  }

  @override
  String get ctaCancel => 'Hủy';

  @override
  String get ctaImport => 'Nhập vào PBSU';

  @override
  String get ctaRedownload => 'Tải lại';

  @override
  String get ctaFileMissing => 'Thiếu tệp, hãy tải lại';

  @override
  String get importSent => 'Đã gửi mod tới PBSU';

  @override
  String get importChooserHint => 'Chọn PBSU để nhập mod này';

  @override
  String get importFailed => 'Không thể nhập mod';

  @override
  String get pbsuMissingTitle => 'Chưa cài đặt PBSU';

  @override
  String get pbsuMissingBody =>
      'Hãy cài đặt Proton Bus Simulator Urbano để nhập mod.';

  @override
  String get pbsuOpenStore => 'Mở Google Play';

  @override
  String get downloadedEmpty => 'Chưa có mod nào được tải';

  @override
  String downloadedTotal(String size) {
    return 'Tổng cộng: $size';
  }

  @override
  String get deleteConfirmTitle => 'Xóa mod?';

  @override
  String deleteConfirmBody(String title) {
    return 'Xóa \"$title\" khỏi thiết bị?';
  }

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String get favoritesEmpty => 'Chưa có mod yêu thích';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsPro => 'Nâng cấp Pro';

  @override
  String get settingsRestore => 'Khôi phục giao dịch';

  @override
  String get settingsPrivacy => 'Chính sách bảo mật';

  @override
  String get settingsTerms => 'Điều khoản sử dụng';

  @override
  String settingsVersion(String v) {
    return 'Phiên bản $v';
  }

  @override
  String get proTitle => 'Busmod Pro';

  @override
  String get proBenefitNoAds => 'Xóa toàn bộ quảng cáo';

  @override
  String get proSubscribe => 'Đăng ký';

  @override
  String get proRestored => 'Đã khôi phục giao dịch';

  @override
  String get proNothingToRestore => 'Không có gì để khôi phục';

  @override
  String get proPurchaseFailed => 'Giao dịch thất bại';

  @override
  String get adLabel => 'Quảng cáo';

  @override
  String get retry => 'Thử lại';

  @override
  String get favoriteRemove => 'Xoá khỏi yêu thích';

  @override
  String get searchClear => 'Xóa';

  @override
  String get proActive => 'Bạn đang dùng Pro';

  @override
  String get favoriteAdd => 'Thêm vào yêu thích';

  @override
  String get proPurchased => 'Chào mừng bạn đến với Pro!';

  @override
  String get proStoreUnavailable =>
      'Cửa hàng không khả dụng. Vui lòng thử lại sau.';

  @override
  String get proRestoreFailed =>
      'Không thể khôi phục giao dịch. Vui lòng thử lại sau.';
}
