import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Busmod'**
  String get appTitle;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again.'**
  String get errorServer;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Local data error.'**
  String get errorCache;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Access denied. Please try again later.'**
  String get errorUnauthorized;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorUnknown;

  /// No description provided for @errorModNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This mod is no longer available'**
  String get errorModNotAvailable;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get navDownloaded;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @typeBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get typeBus;

  /// No description provided for @typeTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get typeTruck;

  /// No description provided for @typeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get typeCar;

  /// No description provided for @typeMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get typeMap;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortPopular;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterBodyType.
  ///
  /// In en, this message translates to:
  /// **'Body type'**
  String get filterBodyType;

  /// No description provided for @filterManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get filterManufacturer;

  /// No description provided for @filterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filterCountry;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search mods'**
  String get searchHint;

  /// No description provided for @searchAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get searchAllTypes;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No mods found'**
  String get searchEmpty;

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get listEmpty;

  /// No description provided for @detailSpecs.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get detailSpecs;

  /// No description provided for @detailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get detailDescription;

  /// No description provided for @detailMoreFrom.
  ///
  /// In en, this message translates to:
  /// **'More from {name}'**
  String detailMoreFrom(String name);

  /// No description provided for @detailMoreLike.
  ///
  /// In en, this message translates to:
  /// **'More like this'**
  String get detailMoreLike;

  /// No description provided for @ctaDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get ctaDownload;

  /// No description provided for @ctaDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {percent}%'**
  String ctaDownloading(int percent);

  /// No description provided for @ctaCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get ctaCancel;

  /// No description provided for @ctaImport.
  ///
  /// In en, this message translates to:
  /// **'Import to PBSU'**
  String get ctaImport;

  /// No description provided for @ctaRedownload.
  ///
  /// In en, this message translates to:
  /// **'Download again'**
  String get ctaRedownload;

  /// No description provided for @ctaFileMissing.
  ///
  /// In en, this message translates to:
  /// **'File missing, download again'**
  String get ctaFileMissing;

  /// No description provided for @importSent.
  ///
  /// In en, this message translates to:
  /// **'Mod sent to PBSU'**
  String get importSent;

  /// No description provided for @importChooserHint.
  ///
  /// In en, this message translates to:
  /// **'Choose PBSU to import this mod'**
  String get importChooserHint;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import the mod'**
  String get importFailed;

  /// No description provided for @pbsuMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'PBSU not installed'**
  String get pbsuMissingTitle;

  /// No description provided for @pbsuMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Install Proton Bus Simulator Urbano to import mods.'**
  String get pbsuMissingBody;

  /// No description provided for @pbsuOpenStore.
  ///
  /// In en, this message translates to:
  /// **'Open Google Play'**
  String get pbsuOpenStore;

  /// No description provided for @downloadedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No downloaded mods'**
  String get downloadedEmpty;

  /// No description provided for @downloadedTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {size}'**
  String downloadedTotal(String size);

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete mod?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" from your device?'**
  String deleteConfirmBody(String title);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmpty;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsPro.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get settingsPro;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestore;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {v}'**
  String settingsVersion(String v);

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Busmod Pro'**
  String get proTitle;

  /// No description provided for @proBenefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads'**
  String get proBenefitNoAds;

  /// No description provided for @proSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get proSubscribe;

  /// No description provided for @proRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get proRestored;

  /// No description provided for @proNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore'**
  String get proNothingToRestore;

  /// No description provided for @proPending.
  ///
  /// In en, this message translates to:
  /// **'Your payment is pending. Pro will unlock when it is confirmed.'**
  String get proPending;

  /// No description provided for @proPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get proPurchaseFailed;

  /// No description provided for @adLabel.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get adLabel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemove;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'You are Pro'**
  String get proActive;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAdd;

  /// No description provided for @proPurchased.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pro!'**
  String get proPurchased;

  /// No description provided for @proStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Store unavailable. Try again later.'**
  String get proStoreUnavailable;

  /// No description provided for @proRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore purchases. Try again later.'**
  String get proRestoreFailed;

  /// No description provided for @ctaDownloadingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get ctaDownloadingUnknown;

  /// No description provided for @filterActiveSemantics.
  ///
  /// In en, this message translates to:
  /// **'Filters, active'**
  String get filterActiveSemantics;

  /// No description provided for @modDownloadsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} downloads'**
  String modDownloadsCount(int count);

  /// No description provided for @deleteModSemantics.
  ///
  /// In en, this message translates to:
  /// **'Delete {title}'**
  String deleteModSemantics(String title);

  /// No description provided for @favoriteRemoveSemantics.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from favorites'**
  String favoriteRemoveSemantics(String title);

  /// No description provided for @errorStorageFull.
  ///
  /// In en, this message translates to:
  /// **'Not enough storage space on your device.'**
  String get errorStorageFull;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
