/// Single place to swap ad units. TEST IDs ONLY: replace with production ids
/// before release. The AdMob app id lives in the manifest placeholder
/// `admobAppId`, not here.
abstract final class AdUnitIds {
  /// Devices that receive test ads in debug builds. Copy the id from the log
  /// line "Use RequestConfiguration.Builder.setTestDeviceIds". May be empty.
  static const List<String> testDeviceIds = <String>[];

  // Official AdMob sample units (Android).
  static const String banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String native = 'ca-app-pub-3940256099942544/2247696110';
  static const String appOpen = 'ca-app-pub-3940256099942544/9257395921';
}

/// The four Yandex ad units.
typedef YandexUnits = ({
  String banner,
  String interstitial,
  String native,
  String appOpen,
});

/// Yandex Mobile Ads units. Demo units only, see [AdUnitIds].
abstract final class YandexAdUnitIds {
  static const YandexUnits demo = (
    banner: 'demo-banner-yandex',
    interstitial: 'demo-interstitial-yandex',
    native: 'demo-native-content-yandex',
    appOpen: 'demo-appopenad-yandex',
  );

  static YandexUnits get current => demo;
}
