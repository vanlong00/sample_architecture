import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/presentation/widgets/downloaded_tile.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const record = ModDownloadRecord(
  sourceId: 7,
  title: 'Big Bus',
  type: ModType.bus,
  relPath: 'mods/7.zip',
  sizeBytes: 2048,
  createdAtMs: 1,
);

Widget app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('shows title, uppercased extension and size', (t) async {
    await t.pumpWidget(
      app(
        DownloadedTile(record: record, onImport: () async {}, onDelete: () {}),
      ),
    );
    expect(find.text('Big Bus'), findsOneWidget);
    expect(find.text('ZIP · 2.0 KB'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus_outlined), findsOneWidget);
  });

  testWidgets('import and delete callbacks fire', (t) async {
    var imported = 0;
    var deleted = 0;
    await t.pumpWidget(
      app(
        DownloadedTile(
          record: record,
          onImport: () async => imported++,
          onDelete: () => deleted++,
        ),
      ),
    );
    await t.tap(find.text('Import to PBSU'));
    await t.tap(find.byTooltip('Delete Big Bus'));
    expect(imported, 1);
    expect(deleted, 1);
  });

  testWidgets('missing: subtitle shown and Import disabled, delete works', (
    t,
  ) async {
    var imported = 0;
    var deleted = 0;
    await t.pumpWidget(
      app(
        DownloadedTile(
          record: record,
          missing: true,
          onImport: () async => imported++,
          onDelete: () => deleted++,
        ),
      ),
    );
    expect(find.text('File missing, download again'), findsOneWidget);
    await t.tap(find.text('Import to PBSU'), warnIfMissed: false);
    await t.tap(find.byTooltip('Delete Big Bus'));
    expect(imported, 0);
    expect(deleted, 1);
  });

  testWidgets('delete button meets 48dp touch target', (t) async {
    await t.pumpWidget(
      app(
        DownloadedTile(record: record, onImport: () async {}, onDelete: () {}),
      ),
    );
    final size = t.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
