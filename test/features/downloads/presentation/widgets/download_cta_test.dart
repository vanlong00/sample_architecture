import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/downloads/data/models/mod_download_record.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_state.dart';
import 'package:busmod/features/downloads/presentation/widgets/download_cta.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockModDownloadCubit extends MockCubit<ModDownloadState>
    implements ModDownloadCubit {}

class FakeAds extends Fake implements AdsService {
  FakeAds({this.throws = false});

  final bool throws;
  int shown = 0;

  @override
  Future<void> showInterstitialAd({
    InterstitialTrigger trigger = InterstitialTrigger.normal,
  }) async {
    shown++;
    if (throws) throw StateError('ad boom');
  }
}

class SlowAds extends Fake implements AdsService {
  SlowAds(this.gate);

  final Future<void> gate;
  int shown = 0;

  @override
  Future<void> showInterstitialAd({
    InterstitialTrigger trigger = InterstitialTrigger.normal,
  }) {
    shown++;
    return gate;
  }
}

const mod = ModDetail(
  sourceId: 7,
  type: ModType.truck,
  title: 'Volvo',
  download: ModDownload(storageUrl: 'https://cdn/x.zip'),
);
const record = ModDownloadRecord(
  sourceId: 7,
  title: 'Volvo',
  type: ModType.truck,
  relPath: 'mods/7.zip',
  sizeBytes: 1,
  createdAtMs: 1,
);

void main() {
  late MockModDownloadCubit cubit;

  setUp(() {
    cubit = MockModDownloadCubit();
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.start(mod)).thenAnswer((_) async {});
    when(cubit.cancel).thenReturn(null);
    when(() => cubit.check(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    if (getIt.isRegistered<AdsService>()) await getIt.reset();
  });

  Future<void> pump(
    WidgetTester t,
    ModDownloadState state, {
    ModDetail detail = mod,
  }) async {
    whenListen(
      cubit,
      const Stream<ModDownloadState>.empty(),
      initialState: state,
    );
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: BlocProvider<ModDownloadCubit>.value(
            value: cubit,
            child: DownloadCta(mod: detail),
          ),
        ),
      ),
    );
  }

  testWidgets('not downloadable renders nothing', (t) async {
    await pump(
      t,
      const ModDownloadState.idle(),
      detail: const ModDetail(sourceId: 1, type: ModType.truck, title: 'x'),
    );
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('checking: disabled placeholder, never Download', (t) async {
    await pump(t, const ModDownloadState.checking());
    expect(find.text('Download'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(t.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });

  testWidgets('idle: Download starts once without AdsService', (t) async {
    await pump(t, const ModDownloadState.idle());
    await t.tap(find.text('Download'));
    await t.pump();
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('idle: shows ad then starts', (t) async {
    final ads = FakeAds();
    getIt.registerSingleton<AdsService>(ads);
    await pump(t, const ModDownloadState.idle());
    await t.tap(find.text('Download'));
    await t.pump();
    expect(ads.shown, 1);
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('idle: a throwing ad never blocks the download', (t) async {
    getIt.registerSingleton<AdsService>(FakeAds(throws: true));
    await pump(t, const ModDownloadState.idle());
    await t.tap(find.text('Download'));
    await t.pump();
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('downloading: determinate progress, percent and cancel', (
    t,
  ) async {
    await pump(t, const ModDownloadState.downloading(received: 25, total: 100));
    final bar = t.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 0.25);
    expect(find.text('Downloading 25%'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    verify(cubit.cancel).called(1);
  });

  testWidgets('downloading: indeterminate when total is unknown', (t) async {
    await pump(t, const ModDownloadState.downloading(received: 5, total: -1));
    final bar = t.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, isNull);
    expect(find.textContaining('Downloading'), findsNothing);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets(
    'downloaded: Import calls importToGame and is disabled meanwhile',
    (t) async {
      final pending = Completer<Either<Failure, ImportOutcome>>();
      when(() => cubit.importToGame(record)).thenAnswer((_) => pending.future);
      await pump(t, const ModDownloadState.downloaded(record));

      await t.tap(find.text('Import to PBSU'));
      await t.pump();
      // Second tap while running is ignored.
      await t.tap(find.text('Import to PBSU'), warnIfMissed: false);
      await t.pump();
      verify(() => cubit.importToGame(record)).called(1);
      expect(
        t.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      pending.complete(right(ImportOutcome.sent));
      await t.pumpAndSettle();
      expect(find.text('Mod sent to PBSU'), findsOneWidget);
      expect(
        t.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    },
  );

  testWidgets('fileMissing: message and Download again restarts', (t) async {
    await pump(t, const ModDownloadState.fileMissing(record));
    expect(find.text('File missing, download again'), findsOneWidget);
    await t.tap(find.text('Download again'));
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('failure: neutral message and Retry restarts', (t) async {
    await pump(t, const ModDownloadState.failure(Failure.network()));
    expect(find.text('No internet connection.'), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('failure 404: message, no Retry', (t) async {
    await pump(t, const ModDownloadState.failure(Failure.server(code: 404)));
    expect(find.text('Retry'), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.textContaining('available'), findsOneWidget);
  });

  testWidgets('failure with previous copy: Import and Retry together', (
    t,
  ) async {
    when(
      () => cubit.importToGame(record),
    ).thenAnswer((_) async => right(ImportOutcome.sent));
    await pump(t, const ModDownloadState.failure(Failure.network(), record));
    expect(find.text('No internet connection.'), findsOneWidget);
    expect(find.text('Import to PBSU'), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => cubit.start(mod)).called(1);
    await t.tap(find.text('Import to PBSU'));
    await t.pumpAndSettle();
    verify(() => cubit.importToGame(record)).called(1);
  });

  testWidgets('failure 404 with previous copy: Import only', (t) async {
    await pump(
      t,
      const ModDownloadState.failure(Failure.server(code: 404), record),
    );
    expect(find.text('Import to PBSU'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('failed first download shows only Retry', (t) async {
    await pump(t, const ModDownloadState.failure(Failure.network()));
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Import to PBSU'), findsNothing);
  });

  testWidgets('idle: double tap while the ad loads counts one ad', (t) async {
    final ad = Completer<void>();
    final ads = SlowAds(ad.future);
    getIt.registerSingleton<AdsService>(ads);
    await pump(t, const ModDownloadState.idle());
    await t.tap(find.text('Download'));
    await t.pump();
    await t.tap(find.text('Download'), warnIfMissed: false);
    await t.pump();
    expect(ads.shown, 1);
    ad.complete();
    await t.pump();
    verify(() => cubit.start(mod)).called(1);
  });

  testWidgets('checkFailure: Retry re-checks and never starts', (t) async {
    await pump(t, const ModDownloadState.checkFailure(Failure.cache()));
    await t.tap(find.text('Retry'));
    verify(() => cubit.check(7)).called(1);
    verifyNever(() => cubit.start(mod));
  });

  testWidgets('downloaded: file gone -> missing snackbar and re-check', (
    t,
  ) async {
    when(
      () => cubit.importToGame(record),
    ).thenAnswer((_) async => left(const Failure.cache()));
    await pump(t, const ModDownloadState.downloaded(record));
    await t.tap(find.text('Import to PBSU'));
    await t.pumpAndSettle();
    expect(find.text('File missing, download again'), findsOneWidget);
    verify(() => cubit.check(7)).called(1);
  });
}
