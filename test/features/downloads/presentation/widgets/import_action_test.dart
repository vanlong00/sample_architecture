import 'package:busmod/core/ads/ads_service.dart';
import 'package:busmod/core/config/app_links.dart';
import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/downloads/data/repositories/download_repository.dart';
import 'package:busmod/features/downloads/presentation/widgets/import_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  FakeLauncher({this.marketResult = true, this.marketThrows = false});

  final bool marketResult;
  final bool marketThrows;
  final launched = <String>[];

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    expect(options.mode, PreferredLaunchMode.externalApplication);
    if (url.startsWith('market:')) {
      if (marketThrows) throw StateError('no handler');
      return marketResult;
    }
    return true;
  }
}

class FakeAds extends Fake implements AdsService {
  int suppressed = 0;

  @override
  void suppressNextAppOpen() => suppressed++;
}

void main() {
  late FakeLauncher launcher;

  setUp(() => UrlLauncherPlatform.instance = launcher = FakeLauncher());
  tearDown(() async {
    if (getIt.isRegistered<AdsService>()) await getIt.reset();
  });

  Future<void> run(
    WidgetTester t,
    Either<Failure, ImportOutcome> result, {
    FakeLauncher? fake,
    VoidCallback? onFileMissing,
  }) async {
    if (fake != null) UrlLauncherPlatform.instance = launcher = fake;
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => runImport(
                context,
                () async => result,
                onFileMissing: onFileMissing,
              ),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('go'));
    await t.pumpAndSettle();
  }

  testWidgets('sent -> snackbar', (t) async {
    await run(t, right(ImportOutcome.sent));
    expect(find.text('Mod sent to PBSU'), findsOneWidget);
  });

  testWidgets('chooserOpened -> hint', (t) async {
    await run(t, right(ImportOutcome.chooserOpened));
    expect(find.text('Choose PBSU to import this mod'), findsOneWidget);
  });

  testWidgets('failed -> error snackbar', (t) async {
    await run(t, right(ImportOutcome.failed));
    expect(find.text('Could not import the mod'), findsOneWidget);
  });

  testWidgets('fileMissing -> file missing snackbar and callback', (t) async {
    var missing = 0;
    await run(
      t,
      right(ImportOutcome.fileMissing),
      onFileMissing: () => missing++,
    );
    expect(find.text('File missing, download again'), findsOneWidget);
    expect(missing, 1);
  });

  testWidgets('Left(cache) storage error -> failed snackbar, no callback', (
    t,
  ) async {
    var missing = 0;
    await run(t, left(const Failure.cache()), onFileMissing: () => missing++);
    expect(find.text('Could not import the mod'), findsOneWidget);
    expect(find.text('File missing, download again'), findsNothing);
    expect(missing, 0);
  });

  testWidgets('other Left -> generic error snackbar, no callback', (t) async {
    var missing = 0;
    await run(t, left(const Failure.network()), onFileMissing: () => missing++);
    expect(find.text('Could not import the mod'), findsOneWidget);
    expect(missing, 0);
  });

  testWidgets('notInstalled -> dialog; cancel closes without launching', (
    t,
  ) async {
    await run(t, right(ImportOutcome.notInstalled));
    expect(find.text('PBSU not installed'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(launcher.launched, isEmpty);
  });

  testWidgets('open store launches market://', (t) async {
    await run(t, right(ImportOutcome.notInstalled));
    await t.tap(find.text('Open Google Play'));
    await t.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(launcher.launched, [pbsuPlayStore]);
  });

  testWidgets('falls back to https when market:// cannot launch', (t) async {
    await run(
      t,
      right(ImportOutcome.notInstalled),
      fake: FakeLauncher(marketResult: false),
    );
    await t.tap(find.text('Open Google Play'));
    await t.pumpAndSettle();
    expect(launcher.launched, [pbsuPlayStore, pbsuPlayStoreWeb]);
  });

  testWidgets('falls back to https when market:// throws', (t) async {
    await run(
      t,
      right(ImportOutcome.notInstalled),
      fake: FakeLauncher(marketThrows: true),
    );
    await t.tap(find.text('Open Google Play'));
    await t.pumpAndSettle();
    expect(launcher.launched, [pbsuPlayStore, pbsuPlayStoreWeb]);
  });

  testWidgets('import suppresses the next app-open ad', (t) async {
    final ads = FakeAds();
    getIt.registerSingleton<AdsService>(ads);
    await run(t, right(ImportOutcome.sent));
    expect(ads.suppressed, 1);
  });

  testWidgets('opening the Play Store suppresses the next app-open ad', (
    t,
  ) async {
    final ads = FakeAds();
    getIt.registerSingleton<AdsService>(ads);
    await run(t, right(ImportOutcome.notInstalled));
    expect(ads.suppressed, 1); // from runImport
    await t.tap(find.text('Open Google Play'));
    await t.pumpAndSettle();
    expect(ads.suppressed, 2);
  });
}
