// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Busmod';

  @override
  String get errorServer => 'Server error. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorCache => 'Local data error.';

  @override
  String get errorUnauthorized => 'Access denied. Please try again later.';

  @override
  String get errorUnknown => 'Something went wrong.';

  @override
  String get errorModNotAvailable => 'This mod is no longer available';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navDownloaded => 'Downloaded';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navSettings => 'Settings';

  @override
  String get typeBus => 'Bus';

  @override
  String get typeTruck => 'Truck';

  @override
  String get typeCar => 'Car';

  @override
  String get typeMap => 'Map';

  @override
  String get sortPopular => 'Popular';

  @override
  String get sortNewest => 'Newest';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterBodyType => 'Body type';

  @override
  String get filterManufacturer => 'Manufacturer';

  @override
  String get filterCountry => 'Country';

  @override
  String get filterAll => 'All';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterReset => 'Reset';

  @override
  String get searchHint => 'Search mods';

  @override
  String get searchAllTypes => 'All types';

  @override
  String get searchEmpty => 'No mods found';

  @override
  String get listEmpty => 'Nothing here yet';

  @override
  String get detailSpecs => 'Specifications';

  @override
  String get detailDescription => 'Description';

  @override
  String detailMoreFrom(String name) {
    return 'More from $name';
  }

  @override
  String get detailMoreLike => 'More like this';

  @override
  String get ctaDownload => 'Download';

  @override
  String ctaDownloading(int percent) {
    return 'Downloading $percent%';
  }

  @override
  String get ctaCancel => 'Cancel';

  @override
  String get ctaImport => 'Import to PBSU';

  @override
  String get ctaRedownload => 'Download again';

  @override
  String get ctaFileMissing => 'File missing, download again';

  @override
  String get importSent => 'Mod sent to PBSU';

  @override
  String get importChooserHint => 'Choose PBSU to import this mod';

  @override
  String get importFailed => 'Could not import the mod';

  @override
  String get pbsuMissingTitle => 'PBSU not installed';

  @override
  String get pbsuMissingBody =>
      'Install Proton Bus Simulator Urbano to import mods.';

  @override
  String get pbsuOpenStore => 'Open Google Play';

  @override
  String get downloadedEmpty => 'No downloaded mods';

  @override
  String downloadedTotal(String size) {
    return 'Total: $size';
  }

  @override
  String get deleteConfirmTitle => 'Delete mod?';

  @override
  String deleteConfirmBody(String title) {
    return 'Delete \"$title\" from your device?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsPro => 'Go Pro';

  @override
  String get settingsRestore => 'Restore purchases';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String settingsVersion(String v) {
    return 'Version $v';
  }

  @override
  String get proTitle => 'Busmod Pro';

  @override
  String get proBenefitNoAds => 'Remove all ads';

  @override
  String get proSubscribe => 'Subscribe';

  @override
  String get proRestored => 'Purchases restored';

  @override
  String get proNothingToRestore => 'Nothing to restore';

  @override
  String get proPurchaseFailed => 'Purchase failed';

  @override
  String get adLabel => 'Ad';

  @override
  String get retry => 'Retry';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get searchClear => 'Clear';

  @override
  String get proActive => 'You are Pro';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get proPurchased => 'Welcome to Pro!';

  @override
  String get proStoreUnavailable => 'Store unavailable. Try again later.';

  @override
  String get proRestoreFailed =>
      'Could not restore purchases. Try again later.';

  @override
  String get ctaDownloadingUnknown => 'Downloading…';

  @override
  String get filterActiveSemantics => 'Filters, active';

  @override
  String modDownloadsCount(int count) {
    return '$count downloads';
  }

  @override
  String deleteModSemantics(String title) {
    return 'Delete $title';
  }

  @override
  String favoriteRemoveSemantics(String title) {
    return 'Remove $title from favorites';
  }

  @override
  String get errorStorageFull => 'Not enough storage space on your device.';
}
