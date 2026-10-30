import 'dart:io';

/// One "house" app in the house ad, read from Remote Config (`more_apps`).
///
/// [banner] is a landscape image (feature graphic). Only the medium native
/// cell uses it; without it the medium cell falls back to an enlarged icon.
///
/// [packageName] is for the Play Store, [appStoreId] for the App Store. On iOS
/// without [appStoreId], it falls back to an App Store search page for [name].
// ponytail: hand-written (no freezed) so it needs no build_runner and keeps
// pvp's names/fields; no copyWith/==, add when a caller needs them.
class MoreApp {
  const MoreApp({
    this.name = '',
    this.description = '',
    this.icon = '',
    this.banner = '',
    this.packageName = '',
    this.appStoreId,
  });

  /// Lenient: missing or wrongly typed fields fall back to their defaults.
  factory MoreApp.fromJson(Map<String, dynamic> json) {
    String str(String key) => json[key] is String ? json[key] as String : '';
    final id = json['appStoreId'];
    return MoreApp(
      name: str('name'),
      description: str('description'),
      icon: str('icon'),
      banner: str('banner'),
      packageName: str('packageName'),
      appStoreId: id is String ? id : null,
    );
  }

  final String name;
  final String description;
  final String icon;
  final String banner;
  final String packageName;
  final String? appStoreId;

  /// Store link for the current platform. `null` means this app cannot be
  /// promoted here (on iOS: neither [appStoreId] nor [name]; on Android: no
  /// [packageName]). The caller filters it out instead of opening a broken
  /// store page.
  String? get storeUrl {
    if (Platform.isIOS || Platform.isMacOS) {
      final id = appStoreId;
      if (id != null && id.isNotEmpty) {
        return 'https://apps.apple.com/app/id$id';
      }
      return name.isEmpty
          ? null
          : 'https://apps.apple.com/search?term=${Uri.encodeComponent(name)}';
    }
    return packageName.isEmpty
        ? null
        : 'https://play.google.com/store/apps/details?id=$packageName';
  }
}
