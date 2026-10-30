import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/l10n/app_localizations_en.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_state.dart';
import 'package:busmod/features/downloads/presentation/pages/downloaded_page.dart';
import 'package:busmod/features/downloads/presentation/widgets/downloaded_tile.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadedCubit extends MockCubit<DownloadedState>
    implements DownloadedCubit {}

ModDownloadRecord rec(int id, {String ext = 'zip', int size = 1024}) =>
    ModDownloadRecord(
      sourceId: id,
      title: 'Mod $id',
      type: ModType.bus,
      relPath: 'mods/$id.$ext',
      sizeBytes: size,
      createdAtMs: id,
    );

void main() {
  late MockDownloadedCubit cubit;

  setUpAll(() => registerFallbackValue(rec(0)));

  setUp(() {
    cubit = MockDownloadedCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.delete(any())).thenAnswer((_) async => right(unit));
    when(() => cubit.markMissing(any())).thenAnswer((_) async {});
    when(
      () => cubit.importToGame(any()),
    ).thenAnswer((_) async => const Right(ImportOutcome.sent));
  });

  Future<void> pump(WidgetTester t, DownloadedState state) async {
    whenListen(
      cubit,
      const Stream<DownloadedState>.empty(),
      initialState: state,
    );
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: BlocProvider<DownloadedCubit>.value(
          value: cubit,
          child: const DownloadedPage(),
        ),
      ),
    );
  }

  testWidgets('loading shows progress without calling load', (t) async {
    await pump(t, const DownloadedState.loading());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verifyNever(() => cubit.load());
  });

  testWidgets('initial shows progress and triggers load', (t) async {
    await pump(t, const DownloadedState.initial());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(() => cubit.load()).called(1);
  });

  testWidgets('empty shows downloadedEmpty', (t) async {
    await pump(t, const DownloadedState.success(records: [], totalBytes: 0));
    expect(find.text('No downloaded mods'), findsOneWidget);
    expect(find.byType(DownloadedTile), findsNothing);
  });

  testWidgets('failure shows localized error and retry calls load', (t) async {
    await pump(t, const DownloadedState.failure(Failure.network()));
    expect(find.text(AppLocalizationsEn().errorNetwork), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => cubit.load()).called(1);
  });

  testWidgets('success shows total, subtitles and keyed tiles', (t) async {
    await pump(
      t,
      DownloadedState.success(
        records: [
          rec(1),
          rec(2, ext: 'rar', size: 2048),
        ],
        totalBytes: 3072,
      ),
    );
    expect(find.text('Total: 3.0 KB'), findsOneWidget);
    expect(find.byType(DownloadedTile), findsNWidgets(2));
    expect(find.text('ZIP · 1.0 KB'), findsOneWidget);
    expect(find.text('RAR · 2.0 KB'), findsOneWidget);
    expect(find.byKey(const ValueKey(1)), findsOneWidget);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);
    // null thumbUrl: placeholder only, no image fetch
    expect(find.byIcon(Icons.directions_bus_outlined), findsNWidgets(2));
  });

  testWidgets('import calls cubit.importToGame with the record', (t) async {
    final r = rec(5);
    await pump(t, DownloadedState.success(records: [r], totalBytes: 1024));
    await t.tap(find.text('Import to PBSU'));
    await t.pump();
    verify(() => cubit.importToGame(r)).called(1);
  });

  testWidgets('delete confirmed calls cubit.delete', (t) async {
    final r = rec(5);
    await pump(t, DownloadedState.success(records: [r], totalBytes: 1024));
    await t.tap(find.byTooltip('Delete'));
    await t.pumpAndSettle();
    expect(find.text('Delete mod?'), findsOneWidget);
    expect(find.text('Delete "Mod 5" from your device?'), findsOneWidget);
    await t.tap(find.widgetWithText(TextButton, 'Delete'));
    await t.pumpAndSettle();
    verify(() => cubit.delete(r)).called(1);
  });

  testWidgets('delete failure keeps the list and shows a snackbar', (t) async {
    final r = rec(5);
    when(
      () => cubit.delete(any()),
    ).thenAnswer((_) async => left(const Failure.network()));
    await pump(t, DownloadedState.success(records: [r], totalBytes: 1024));
    await t.tap(find.byTooltip('Delete'));
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(TextButton, 'Delete'));
    await t.pumpAndSettle();
    expect(find.text(AppLocalizationsEn().errorNetwork), findsOneWidget);
    expect(find.byType(DownloadedTile), findsOneWidget);
  });

  testWidgets('import with missing file marks the record', (t) async {
    final r = rec(5);
    when(
      () => cubit.importToGame(any()),
    ).thenAnswer((_) async => left(const Failure.cache()));
    await pump(t, DownloadedState.success(records: [r], totalBytes: 1024));
    await t.tap(find.text('Import to PBSU'));
    await t.pumpAndSettle();
    verify(() => cubit.markMissing(r)).called(1);
    expect(find.text('File missing, download again'), findsOneWidget);
  });

  testWidgets('double tap on Import fires one import', (t) async {
    final pending = Completer<Either<Failure, ImportOutcome>>();
    when(() => cubit.importToGame(any())).thenAnswer((_) => pending.future);
    await pump(t, DownloadedState.success(records: [rec(5)], totalBytes: 1));
    await t.tap(find.text('Import to PBSU'));
    await t.pump();
    await t.tap(find.text('Import to PBSU'), warnIfMissed: false);
    await t.pump();
    verify(() => cubit.importToGame(any())).called(1);
    pending.complete(right(ImportOutcome.sent));
    await t.pumpAndSettle();
  });

  testWidgets('missing record shows subtitle', (t) async {
    await pump(
      t,
      DownloadedState.success(
        records: [rec(5)],
        totalBytes: 1,
        missingIds: const {5},
      ),
    );
    expect(find.text('File missing, download again'), findsOneWidget);
  });

  testWidgets('delete cancelled does not call cubit.delete', (t) async {
    await pump(t, DownloadedState.success(records: [rec(5)], totalBytes: 1024));
    await t.tap(find.byTooltip('Delete'));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    verifyNever(() => cubit.delete(any()));
    expect(find.text('Delete mod?'), findsNothing);
  });
}
