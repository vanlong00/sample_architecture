import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/config/app_links.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_cubit.dart';
import 'package:busmod/features/premium/presentation/bloc/paywall_state.dart';
import 'package:busmod/features/premium/presentation/bloc/pro_status_cubit.dart';
import 'package:busmod/features/settings/presentation/bloc/locale_cubit.dart';
import 'package:busmod/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:busmod/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

class MockLocaleCubit extends MockCubit<Locale> implements LocaleCubit {}

class MockProStatusCubit extends MockCubit<bool> implements ProStatusCubit {}

class MockPaywallCubit extends MockCubit<PaywallState>
    implements PaywallCubit {}

class FakeLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final launched = <String>[];

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    expect(options.mode, PreferredLaunchMode.externalApplication);
    return true;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));
  });

  late MockThemeCubit theme;
  late MockLocaleCubit locale;
  late MockProStatusCubit pro;
  late MockPaywallCubit paywall;
  late StreamController<PaywallState> paywallStream;
  late FakeLauncher launcher;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Busmod',
      packageName: 'com.pamg.busmod',
      version: '1.2.3',
      buildNumber: '4',
      buildSignature: '',
    );
    launcher = FakeLauncher();
    UrlLauncherPlatform.instance = launcher;
    theme = MockThemeCubit();
    locale = MockLocaleCubit();
    pro = MockProStatusCubit();
    paywall = MockPaywallCubit();
    paywallStream = StreamController<PaywallState>.broadcast();
    when(() => theme.setMode(any())).thenReturn(null);
    when(() => locale.setLocale(any())).thenReturn(null);
    when(() => paywall.restore()).thenAnswer((_) async {});
    whenListen(
      theme,
      const Stream<ThemeMode>.empty(),
      initialState: ThemeMode.system,
    );
    whenListen(
      locale,
      const Stream<Locale>.empty(),
      initialState: const Locale('en'),
    );
    whenListen(pro, const Stream<bool>.empty(), initialState: false);
    whenListen(
      paywall,
      paywallStream.stream,
      initialState: const PaywallState.idle(),
    );
  });

  tearDown(() => paywallStream.close());

  Future<void> pump(WidgetTester t) async {
    // Tall viewport so the whole (lazy) list is built.
    t.view.physicalSize = const Size(800, 2400);
    addTearDown(t.view.resetPhysicalSize);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SettingsPage()),
        GoRoute(path: '/pro', builder: (_, _) => const Text('pro page')),
      ],
    );
    await t.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: theme),
          BlocProvider<LocaleCubit>.value(value: locale),
          BlocProvider<ProStatusCubit>.value(value: pro),
          BlocProvider<PaywallCubit>.value(value: paywall),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
    );
    await t.pump();
    await t.pump(const Duration(seconds: 1));
  }

  testWidgets('theme tap calls setMode', (t) async {
    await pump(t);
    await t.tap(find.text('Dark'));
    verify(() => theme.setMode(ThemeMode.dark)).called(1);
  });

  testWidgets('language tap calls setLocale', (t) async {
    await pump(t);
    await t.tap(find.text('Tiếng Việt'));
    verify(() => locale.setLocale(const Locale('vi'))).called(1);
  });

  testWidgets('pro tile navigates to /pro', (t) async {
    await pump(t);
    await t.tap(find.text('Go Pro'));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('pro page'), findsOneWidget);
  });

  testWidgets('owned pro shows indicator and does not navigate', (t) async {
    whenListen(pro, const Stream<bool>.empty(), initialState: true);
    await pump(t);
    expect(find.text('You are Pro'), findsOneWidget);
    await t.tap(find.text('Go Pro'));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('pro page'), findsNothing);
  });

  testWidgets('restore tap calls restore', (t) async {
    await pump(t);
    await t.tap(find.text('Restore purchases'));
    verify(() => paywall.restore()).called(1);
  });

  testWidgets('restoring shows progress and disables restore', (t) async {
    whenListen(
      paywall,
      paywallStream.stream,
      initialState: const PaywallState.restoring(),
    );
    await pump(t);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await t.tap(find.text('Restore purchases'));
    verifyNever(() => paywall.restore());
  });

  for (final (state, text) in [
    (const PaywallState.purchased(), 'Welcome to Pro!'),
    (const PaywallState.restored(), 'Purchases restored'),
    (const PaywallState.info('x'), 'Nothing to restore'),
    (const PaywallState.error('boom'), 'Purchase failed'),
    (
      const PaywallState.error('boom', fromRestore: true),
      'Could not restore purchases. Try again later.',
    ),
  ]) {
    testWidgets('${state.runtimeType} shows "$text"', (t) async {
      await pump(t);
      paywallStream.add(state);
      await t.pump();
      await t.pump();
      expect(find.text(text), findsOneWidget);
      expect(find.text('boom'), findsNothing);
    });
  }

  testWidgets('idle and purchasing show no snackbar', (t) async {
    await pump(t);
    paywallStream
      ..add(const PaywallState.purchasing())
      ..add(const PaywallState.idle());
    await t.pump();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('privacy and terms launch externally', (t) async {
    await pump(t);
    await t.tap(find.text('Privacy policy'));
    await t.tap(find.text('Terms of use'));
    await t.pump();
    expect(launcher.launched, [privacyUrl, termsUrl]);
  });

  testWidgets('version row shows version', (t) async {
    await pump(t);
    expect(find.text('Version 1.2.3'), findsOneWidget);
  });
}
