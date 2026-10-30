import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/widgets/app_snackbar.dart';
import 'package:busmod/core/widgets/confirm_dialog.dart';
import 'package:busmod/core/widgets/load_more_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget app(Widget home) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(body: home),
);

void main() {
  group('showConfirmDialog', () {
    Future<bool?> run(
      WidgetTester t,
      String tap, {
      bool dismiss = false,
    }) async {
      bool? result;
      await t.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showConfirmDialog(
                context,
                title: 'T',
                message: 'M',
                confirmLabel: 'Yes',
                cancelLabel: 'No',
                destructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await t.tap(find.text('open'));
      await t.pumpAndSettle();
      expect(find.text('T'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      if (dismiss) {
        await t.tapAt(const Offset(2, 2));
      } else {
        await t.tap(find.text(tap));
      }
      await t.pumpAndSettle();
      return result;
    }

    testWidgets(
      'confirm -> true',
      (t) async => expect(await run(t, 'Yes'), true),
    );
    testWidgets(
      'cancel -> false',
      (t) async => expect(await run(t, 'No'), false),
    );
    testWidgets(
      'dismiss -> false',
      (t) async => expect(await run(t, '', dismiss: true), false),
    );
  });

  group('LoadMoreFooter', () {
    testWidgets('loading shows spinner', (t) async {
      await t.pumpWidget(app(LoadMoreFooter(loading: true, onRetry: () {})));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error shows retry and calls onRetry', (t) async {
      var retried = 0;
      await t.pumpWidget(
        app(
          LoadMoreFooter(loading: false, error: 'x', onRetry: () => retried++),
        ),
      );
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Something went wrong.'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await t.tap(find.text('Retry'));
      expect(retried, 1);
    });

    testWidgets('Failure error shows its localized message next to Retry', (
      t,
    ) async {
      await t.pumpWidget(
        app(
          LoadMoreFooter(
            loading: false,
            error: const Failure.network(),
            onRetry: () {},
          ),
        ),
      );
      expect(find.text('No internet connection.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('idle shows nothing', (t) async {
      await t.pumpWidget(app(LoadMoreFooter(loading: false, onRetry: () {})));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });

  testWidgets('showAppSnackBar shows text and replaces the previous one', (
    t,
  ) async {
    await t.pumpWidget(
      app(
        Builder(
          builder: (context) => Column(
            children: [
              TextButton(
                onPressed: () => context.showAppSnackBar('first'),
                child: const Text('a'),
              ),
              TextButton(
                onPressed: () =>
                    context.showAppSnackBar('second', isError: true),
                child: const Text('b'),
              ),
            ],
          ),
        ),
      ),
    );
    await t.tap(find.text('a'));
    await t.pump();
    expect(find.text('first'), findsOneWidget);
    await t.tap(find.text('b'));
    await t.pump();
    expect(find.text('second'), findsOneWidget);
    expect(find.text('first'), findsNothing);
  });
}
