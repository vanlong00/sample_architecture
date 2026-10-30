// Hermetic real-stack tests for download safety (.part atomicity), the
// app-scoped DownloadManager and the Library screen. REAL Dio + REAL
// repository/data sources + REAL cubits + REAL LocalStore and files; only the
// HTTP adapter, the PBSU channel and the support dir are fake.
import 'dart:async';
import 'dart:io';

import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:busmod/core/storage/local_store.dart';
import 'package:busmod/features/downloads/data/datasources/download_local_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:busmod/features/downloads/data/datasources/pbsu_launcher_datasource.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/bloc/download_manager.dart';
import 'package:busmod/features/downloads/presentation/bloc/downloaded_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_state.dart';
import 'package:busmod/features/downloads/presentation/pages/downloaded_page.dart';
import 'package:busmod/features/downloads/presentation/widgets/download_cta.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/isar_test_setup.dart';

const _cdn = 'cdn.busmod.test';
const _config = AppConfig(
  env: AppEnv.dev,
  baseUrl: 'https://api.busmod.test',
  enableLogging: false,
  appName: 'Busmod (Test)',
);

/// File host. Per path: byte count, optional stall before the 3rd chunk,
/// optional failure status.
class _Cdn implements HttpClientAdapter {
  final requests = <Uri>[];
  final bytes = <String, int>{};
  final stalls = <String, Completer<void>>{};
  final failing = <String>{};

  Iterable<Uri> hits(String path) => requests.where((u) => u.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    requests.add(options.uri);
    if (failing.contains(path)) return ResponseBody.fromString('boom', 500);
    final per = (bytes[path] ?? 100) ~/ 4;
    final stall = stalls[path];
    Stream<Uint8List> body() async* {
      for (var i = 0; i < 4; i++) {
        if (i == 2 && stall != null) await stall.future;
        yield Uint8List.fromList(List.filled(per, i + 1));
      }
    }

    return ResponseBody(
      body(),
      200,
      headers: {
        Headers.contentLengthHeader: ['${per * 4}'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// No thumbnail: widget tests must not build a CachedNetworkImage (it needs
/// path_provider, absent in unit tests).
ModDetail _mod(int id, String file, {String title = 'Mod'}) => ModDetail(
  sourceId: id,
  type: ModType.bus,
  title: '$title $id',
  download: ModDownload(storageUrl: 'https://$_cdn/files/$file'),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Cdn cdn;
  late LocalStore store;
  late Directory support;
  late DownloadLocalDataSource local;
  late DownloadRepositoryImpl repo;
  late DownloadManager manager;
  late List<MethodCall> channelCalls;
  Completer<void>? launchGate;
  var pbsuInstalled = true;
  const channel = MethodChannel('com.pamg.busmod/pbsu');

  File file(String rel) => File('${support.path}/$rel');
  List<String> modFiles() =>
      Directory('${support.path}/mods').listSync().map((e) => e.path).toList()
        ..sort();

  ModDownloadCubit cubit() => ModDownloadCubit(repo, manager);

  setUp(() async {
    cdn = _Cdn();
    final dlDio = buildDownloadDio(_config)..httpClientAdapter = cdn;
    store = await openTestStore();
    support = await Directory.systemTemp.createTemp('busmod_safety_support');
    local = DownloadLocalDataSource(
      store,
      supportDir: () async => support.path,
    );
    channelCalls = [];
    launchGate = null;
    pbsuInstalled = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          channelCalls.add(call);
          if (call.method == 'launch') await launchGate?.future;
          return call.method == 'isInstalled' ? pbsuInstalled : null;
        });
    repo = DownloadRepositoryImpl(
      DownloadRemoteDataSource(dlDio),
      local,
      PbsuLauncherDataSource(channel: channel),
    );
    manager = DownloadManager(repo);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await store.close(deleteFromDisk: true);
    await support.delete(recursive: true);
  });

  Future<void> untilDownloading(ModDownloadCubit c) =>
      c.stream.firstWhere((s) => s is ModDownloadDownloading && s.received > 0);

  group('.part atomicity (real files + record)', () {
    test(
      'during a re-download the old file+record are untouched; cancel '
      'removes only the .part and the CTA falls back to downloaded',
      () async {
        final mod = _mod(1, 'a.zip');
        final first = cubit();
        await first.start(mod); // 100 bytes of the pattern 1,2,3,4
        final before = file('mods/1.zip').readAsBytesSync();
        final recordBefore = local.readRecord(1)!;
        await first.close();

        cdn.bytes['/files/a.zip'] = 200;
        cdn.stalls['/files/a.zip'] = Completer<void>();
        final c = cubit();
        await c.check(1);
        expect(c.state, isA<ModDownloadDownloaded>());
        final running = c.start(mod);
        await untilDownloading(c);

        // Mid-way: the real file is still the OLD content, bytes live in .part.
        expect(file('mods/1.zip.part').existsSync(), isTrue);
        expect(file('mods/1.zip').readAsBytesSync(), before);
        expect(local.readRecord(1)!.sizeBytes, 100);

        c.cancel();
        cdn.stalls['/files/a.zip']!.complete();
        await running;
        await pumpEventQueue();

        expect(file('mods/1.zip.part').existsSync(), isFalse);
        expect(file('mods/1.zip').readAsBytesSync(), before);
        expect(local.readRecord(1), recordBefore);
        expect(c.state, ModDownloadState.downloaded(recordBefore));
        await c.close();
      },
    );

    test('failed re-download: .part removed, old file+record intact', () async {
      final mod = _mod(2, 'a.zip');
      final c = cubit();
      await c.start(mod);
      final before = file('mods/2.zip').readAsBytesSync();
      final recordBefore = local.readRecord(2)!;

      cdn.failing.add('/files/a.zip');
      await c.start(mod);

      expect(c.state, isA<ModDownloadFailure>());
      expect(modFiles(), ['${support.path}/mods/2.zip']); // no .part left
      expect(file('mods/2.zip').readAsBytesSync(), before);
      expect(local.readRecord(2), recordBefore);
      await c.close();
    });

    test(
      'success replaces the real file with the new bytes only at the end',
      () async {
        final c = cubit();
        await c.start(_mod(3, 'a.zip'));
        cdn.bytes['/files/a.zip'] = 200;
        await c.start(_mod(3, 'a.zip'));
        expect(modFiles(), ['${support.path}/mods/3.zip']);
        expect(file('mods/3.zip').lengthSync(), 200);
        expect(local.readRecord(3)!.sizeBytes, 200);
        await c.close();
      },
    );

    test('extension change zip -> rar succeeds: old .zip removed, record '
        'points to the .rar', () async {
      final c = cubit();
      await c.start(_mod(4, 'a.zip'));
      expect(file('mods/4.zip').existsSync(), isTrue);

      await c.start(_mod(4, 'a.rar'));

      expect(modFiles(), ['${support.path}/mods/4.rar']);
      expect(local.readRecord(4)!.relPath, 'mods/4.rar');
      expect((c.state as ModDownloadDownloaded).record.relPath, 'mods/4.rar');
      await c.close();
    });

    test('extension change zip -> rar FAILS: old .zip and its record stay, '
        'nothing else is left', () async {
      final c = cubit();
      await c.start(_mod(5, 'a.zip'));
      final before = file('mods/5.zip').readAsBytesSync();
      final recordBefore = local.readRecord(5)!;

      cdn.failing.add('/files/a.rar');
      await c.start(_mod(5, 'a.rar'));

      expect(c.state, isA<ModDownloadFailure>());
      expect(modFiles(), ['${support.path}/mods/5.zip']);
      expect(file('mods/5.zip').readAsBytesSync(), before);
      expect(local.readRecord(5), recordBefore);
      await c.close();
    });

    test('F1/F2: only storageUrl is requested, extension byte-for-byte, '
        'MIME from importMimeFor', () async {
      final c = cubit();
      await c.start(_mod(6, 'Pack.RaR'));
      final rec = (c.state as ModDownloadDownloaded).record;
      expect(rec.relPath, 'mods/6.RaR');
      expect(cdn.requests.map((u) => '$u'), ['https://$_cdn/files/Pack.RaR']);
      await c.importToGame(rec);
      final launch = channelCalls.singleWhere((m) => m.method == 'launch');
      expect(launch.arguments['mime'], '*/*');
      expect(launch.arguments['path'], '${support.path}/mods/6.RaR');
      await c.close();
    });
  });

  group('DownloadManager (app scoped), real transfers', () {
    test('two cubits starting the same id: exactly ONE HTTP request', () async {
      cdn.stalls['/files/a.zip'] = Completer<void>();
      final a = cubit();
      final b = cubit();
      final mod = _mod(10, 'a.zip');
      final ra = a.start(mod);
      await untilDownloading(a);
      final rb = b.start(mod);
      cdn.stalls['/files/a.zip']!.complete();
      await Future.wait([ra, rb]);
      await pumpEventQueue();

      expect(cdn.hits('/files/a.zip'), hasLength(1));
      expect(a.state, isA<ModDownloadDownloaded>());
      expect(b.state, isA<ModDownloadDownloaded>());
      expect(modFiles(), ['${support.path}/mods/10.zip']);
      await a.close();
      await b.close();
    });

    test('leaving and reopening: closing the cubit does not cancel, the new '
        'cubit shows live progress then the finished file', () async {
      cdn.stalls['/files/a.zip'] = Completer<void>();
      final first = cubit();
      unawaited(first.start(_mod(11, 'a.zip')));
      await untilDownloading(first);
      await first.close();
      expect(file('mods/11.zip.part').existsSync(), isTrue); // still running

      final second = cubit();
      expect(second.state, const ModDownloadState.checking());
      await second.check(11);
      expect(second.state, isA<ModDownloadDownloading>());

      cdn.stalls['/files/a.zip']!.complete();
      await second.stream.firstWhere((s) => s is ModDownloadDownloaded);
      expect(file('mods/11.zip').lengthSync(), 100);
      expect(file('mods/11.zip.part').existsSync(), isFalse);
      expect(cdn.hits('/files/a.zip'), hasLength(1));
      await second.close();
    });

    test('two different ids in parallel do not interfere; cancelling one '
        'leaves the other finishing', () async {
      cdn.stalls['/files/a.zip'] = Completer<void>();
      cdn.stalls['/files/b.rar'] = Completer<void>();
      final a = cubit();
      final b = cubit();
      final ra = a.start(_mod(20, 'a.zip'));
      final rb = b.start(_mod(21, 'b.rar'));
      await Future.wait([untilDownloading(a), untilDownloading(b)]);
      expect(file('mods/20.zip.part').existsSync(), isTrue);
      expect(file('mods/21.rar.part').existsSync(), isTrue);

      a.cancel();
      cdn.stalls['/files/a.zip']!.complete();
      cdn.stalls['/files/b.rar']!.complete();
      await Future.wait([ra, rb]);
      await pumpEventQueue();

      expect(a.state, const ModDownloadState.idle());
      expect(b.state, isA<ModDownloadDownloaded>());
      expect(modFiles(), ['${support.path}/mods/21.rar']);
      expect(local.readRecord(20), isNull);
      expect(local.readRecord(21), isNotNull);
      expect(cdn.requests, hasLength(2));
      await a.close();
      await b.close();
    });

    test('an already downloaded mod is never offered Download: checking, '
        'then downloaded (no idle in between)', () async {
      final seed = cubit();
      await seed.start(_mod(30, 'a.zip'));
      await seed.close();

      final c = cubit();
      final seen = <ModDownloadState>[c.state];
      final sub = c.stream.listen(seen.add);
      await c.check(30);
      await pumpEventQueue();
      await sub.cancel();

      expect(seen.first, const ModDownloadState.checking());
      expect(seen.whereType<ModDownloadIdle>(), isEmpty);
      expect(seen.last, isA<ModDownloadDownloaded>());
      await c.close();
    });

    test('a file deleted outside the app resolves to fileMissing, never '
        'downloaded', () async {
      final seed = cubit();
      await seed.start(_mod(31, 'a.zip'));
      await seed.close();
      file('mods/31.zip').deleteSync();

      final c = cubit();
      await c.check(31);
      expect(c.state, isA<ModDownloadFileMissing>());
      await c.close();
    });
  });

  group('Library (DownloadedPage) on the real stack', () {
    Future<void> seed(WidgetTester t, List<ModDetail> mods) =>
        t.runAsync(() async {
          for (final m in mods) {
            final r = await repo.download(m);
            expect(r.isRight(), isTrue);
          }
        });

    Future<DownloadedCubit> pumpPage(WidgetTester t) async {
      final c = DownloadedCubit(repo);
      // Load with real async first: the page only auto-loads from `initial`.
      await t.runAsync(c.load);
      await t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: BlocProvider.value(value: c, child: const DownloadedPage()),
        ),
      );
      return c;
    }

    /// Real file IO completes outside the fake clock, and each await in the
    /// app code then needs a pump to resume: alternate a few times.
    Future<void> settle(WidgetTester t) async {
      for (var i = 0; i < 6; i++) {
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 40)),
        );
        await t.pump();
      }
    }

    Finder importButton(String title) => find.descendant(
      of: find.ancestor(of: find.text(title), matching: find.byType(Card)),
      matching: find.widgetWithText(FilledButton, 'Import to PBSU'),
    );

    testWidgets('Import on a file deleted outside the app: snackbar, tile '
        'marked missing, Import disabled, Delete still works', (t) async {
      await seed(t, [_mod(40, 'a.zip'), _mod(41, 'b.zip')]);
      file('mods/40.zip').deleteSync(); // deleted outside the app
      final c = await pumpPage(t);
      expect(find.text('File missing, download again'), findsNothing);

      await t.tap(importButton('Mod 40'));
      await settle(t);

      // snackbar + the tile subtitle
      expect(
        find.text('File missing, download again'),
        findsAtLeastNWidgets(1),
      );
      expect(t.widget<FilledButton>(importButton('Mod 40')).onPressed, isNull);
      expect(
        t.widget<FilledButton>(importButton('Mod 41')).onPressed,
        isNotNull,
      );
      expect(channelCalls.where((m) => m.method == 'launch'), isEmpty);

      // Delete on the missing tile: confirm, record gone, other tile stays.
      final deleteBtn = find.descendant(
        of: find.ancestor(of: find.text('Mod 40'), matching: find.byType(Card)),
        matching: find.byTooltip('Delete'),
      );
      await t.tap(deleteBtn);
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(TextButton, 'Delete'));
      await settle(t);

      expect(find.text('Mod 40'), findsNothing);
      expect(find.text('Mod 41'), findsOneWidget);
      expect(local.readRecord(40), isNull);
      expect(local.readRecord(41), isNotNull);
      await t.runAsync(c.close);
    });

    testWidgets('detail CTA: Import on a file deleted outside the app moves '
        'to fileMissing with a Download again action', (t) async {
      final mod = _mod(70, 'a.zip');
      await seed(t, [mod]);
      final c = cubit();
      await t.runAsync(() => c.check(70));
      await t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: BlocProvider.value(
              value: c,
              child: DownloadCta(mod: mod),
            ),
          ),
        ),
      );
      expect(find.text('Import to PBSU'), findsOneWidget);
      file('mods/70.zip').deleteSync();

      await t.tap(find.text('Import to PBSU'));
      await settle(t);

      expect(c.state, isA<ModDownloadFileMissing>());
      expect(find.text('Download again'), findsOneWidget);
      expect(
        find.text('File missing, download again'),
        findsAtLeastNWidgets(1),
      );
      expect(find.text('Import to PBSU'), findsNothing);
      expect(channelCalls.where((m) => m.method == 'launch'), isEmpty);
      await t.runAsync(c.close);
    });

    testWidgets('PBSU not installed: Import shows the explanation dialog '
        'with a Play Store action and never launches', (t) async {
      await seed(t, [_mod(80, 'a.zip')]);
      pbsuInstalled = false;
      final c = await pumpPage(t);

      await t.tap(importButton('Mod 80'));
      await settle(t);

      expect(find.text('PBSU not installed'), findsOneWidget);
      expect(find.text('Open Google Play'), findsOneWidget);
      expect(channelCalls.where((m) => m.method == 'launch'), isEmpty);
      expect(file('mods/80.zip').existsSync(), isTrue); // nothing was lost
      await t.runAsync(c.close);
    });

    testWidgets('double tap on Import launches PBSU exactly once', (t) async {
      await seed(t, [_mod(50, 'a.zip')]);
      launchGate = Completer<void>();
      final c = await pumpPage(t);

      await t.tap(importButton('Mod 50'));
      await t.pump(); // first tap in flight, button disabled
      await t.tap(importButton('Mod 50'), warnIfMissed: false);
      await t.pump();
      launchGate!.complete();
      await settle(t);

      expect(channelCalls.where((m) => m.method == 'launch'), hasLength(1));
      expect(find.text('Mod sent to PBSU'), findsOneWidget);
      await t.runAsync(c.close);
    });

    testWidgets('a corrupt stored record is skipped, the rest renders, and '
        'the corrupt entry is removed', (t) async {
      await seed(t, [_mod(60, 'a.zip')]);
      await t.runAsync(
        () => store.write<Map<String, dynamic>>(
          StoreBoxes.modDownloads,
          '999',
          {'sourceId': 'not-an-int', 'garbage': true},
        ),
      );
      final c = await pumpPage(t);
      await settle(t);

      expect(find.text('Mod 60'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(store.read<Object>(StoreBoxes.modDownloads, '999'), isNull);
      await t.runAsync(c.close);
    });
  });
}
