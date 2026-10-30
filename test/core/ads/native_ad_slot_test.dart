import 'package:busmod/core/ads/more_app.dart';
import 'package:busmod/core/ads/native_ad_template.dart';
import 'package:busmod/core/ads/widgets/more_app_house_ad.dart';
import 'package:busmod/core/analytics/remote_config_service.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteConfig extends Mock implements RemoteConfigService {}

void main() {
  setUp(() {
    final config = _MockRemoteConfig();
    when(config.getMoreApps).thenReturn(const [
      MoreApp(name: 'Other app', description: 'desc', packageName: 'com.x.y'),
    ]);
    getIt.registerSingleton<RemoteConfigService>(config);
  });
  tearDown(getIt.reset);

  Widget host(Widget child) => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: child),
  );

  testWidgets('house ad slot shows the l10n ad label and the app name', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const MoreAppHouseAd(height: 300, template: NativeAdTemplate.medium),
      ),
    );

    expect(find.text('Ad'), findsOneWidget);
    expect(find.text('Other app'), findsOneWidget);
  });

  test('nativeAdOptions carries the ad label to the native layouts', () {
    final options = nativeAdOptions(
      NativeAdTemplate.small,
      ColorScheme.fromSeed(seedColor: Colors.blue),
      'Ad',
    );
    expect(options['adLabel'], 'Ad');
    expect(options['template'], 'small');
  });
}
