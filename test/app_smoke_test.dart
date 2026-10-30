import 'dart:io';

import 'package:busmod/app.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_test_setup.dart';
import 'helpers/di_test_setup.dart';

void main() {
  late Directory dir;
  setUp(() async => dir = await setUpAppDi());
  tearDown(() => tearDownDi(dir));

  Future<void> boot(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('splash -> home with 4 tabs and a card list', (tester) async {
    await boot(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(Tab), findsNWidgets(4));
    expect(find.text('Alpha Bus'), findsOneWidget);
  });

  testWidgets('bottom nav reaches all 5 tabs', (tester) async {
    await boot(tester);

    await openTab(tester, 'Search');
    expect(find.text('Search mods'), findsWidgets);

    await openTab(tester, 'Downloaded');
    expect(find.text('No downloaded mods'), findsOneWidget);

    await openTab(tester, 'Favorites');
    expect(find.text('No favorites yet'), findsOneWidget);

    await openTab(tester, 'Settings');
    expect(find.text('Go Pro'), findsOneWidget);

    await openTab(tester, 'Home');
    expect(find.text('Alpha Bus'), findsOneWidget);
  });

  testWidgets('card tap opens detail without nav bar; back returns', (
    tester,
  ) async {
    await boot(tester);
    await tester.tap(find.text('Alpha Bus'));
    await tester.pumpAndSettle();
    expect(find.text('Detail 11'), findsWidgets);
    expect(find.byType(NavigationBar), findsNothing);

    getIt<AppRouter>().router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('bad mod id redirects to home', (tester) async {
    await boot(tester);
    getIt<AppRouter>().router.go('/mod/abc');
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Alpha Bus'), findsOneWidget);
  });

  testWidgets('settings Pro tile pushes paywall and back', (tester) async {
    await boot(tester);
    await openTab(tester, 'Settings');
    await tester.tap(find.text('Go Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Busmod Pro'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    getIt<AppRouter>().router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Go Pro'), findsOneWidget);
  });
}
