import 'dart:io';

import 'package:busmod/app.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/router/app_router.dart';
import 'package:busmod/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_test_setup.dart';
import '../../helpers/di_test_setup.dart';

void main() {
  test('modDetailOf', () {
    expect(Routes.modDetailOf(7), '/mod/7');
  });

  test('Routes.pro is referenced only by Settings and the router', () {
    final users = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) {
          final s = f.readAsStringSync();
          return s.contains('Routes.pro') || s.contains("'/pro'");
        })
        .map((f) => f.path)
        .toSet();
    expect(users, {
      'lib/core/router/app_router.dart',
      'lib/core/router/routes.dart',
      'lib/features/settings/presentation/pages/settings_page.dart',
    });
  });

  group('router', () {
    late Directory dir;
    setUp(() async => dir = await setUpAppDi());
    tearDown(() => tearDownDi(dir));

    testWidgets('splash goes to home with 5-tab nav bar', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(5));

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Go Pro'), findsOneWidget);
    });

    testWidgets('an explicit platform route cannot skip the splash', (
      tester,
    ) async {
      tester.platformDispatcher.defaultRouteNameTestValue = '/mod/1';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
      await tester.pumpWidget(const App());
      // Splash runs and lands on home; the detail route was never opened.
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Detail 1'), findsNothing);
      expect(
        getIt<AppRouter>().router.routerDelegate.currentConfiguration.uri.path,
        Routes.home,
      );
    });

    testWidgets('mod detail covers nav bar; bad id redirects home', (
      tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      final router = getIt<AppRouter>().router;

      router.go(Routes.modDetailOf(42));
      await tester.pumpAndSettle();
      expect(find.text('Detail 42'), findsWidgets);
      expect(find.byType(NavigationBar), findsNothing);

      router.go('/mod/abc');
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Alpha Bus'), findsOneWidget);
    });
  });
}
