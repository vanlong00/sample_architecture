import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/router/routes.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/widgets/detail_related.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

ModCard card(int i) =>
    ModCard(sourceId: i, type: ModType.bus, title: 'Related $i');

void main() {
  testWidgets('tapping a related card replaces the detail route; Back returns '
      'to the list (no stack growth)', (t) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () => context.push(Routes.modDetailOf(1)),
              child: const Text('list'),
            ),
          ),
        ),
        GoRoute(
          path: Routes.mod,
          builder: (_, s) {
            final id = int.parse(s.pathParameters['sourceId']!);
            return Scaffold(
              body: Column(
                children: [
                  Text('detail $id'),
                  DetailRelated(related: [card(id + 1)]),
                ],
              ),
            );
          },
        ),
      ],
    );
    await t.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );
    await t.tap(find.text('list'));
    await t.pumpAndSettle();
    expect(find.text('detail 1'), findsOneWidget);

    for (final next in [2, 3]) {
      await t.tap(find.text('Related $next'));
      await t.pumpAndSettle();
      expect(find.text('detail $next'), findsOneWidget);
      // Earlier detail pages are gone, not kept offstage under this one.
      expect(
        find.text('detail ${next - 1}', skipOffstage: false),
        findsNothing,
      );
    }

    router.pop();
    await t.pumpAndSettle();
    expect(find.text('list'), findsOneWidget);
  });
}
