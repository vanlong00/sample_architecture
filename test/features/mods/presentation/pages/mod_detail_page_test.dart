import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_cubit.dart';
import 'package:busmod/features/downloads/presentation/bloc/mod_download_state.dart';
import 'package:busmod/features/downloads/presentation/widgets/download_cta.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:busmod/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_detail_state.dart';
import 'package:busmod/features/mods/presentation/pages/mod_detail_page.dart';
import 'package:busmod/features/mods/presentation/widgets/detail_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockModDetailCubit extends MockCubit<ModDetailState>
    implements ModDetailCubit {}

class MockModDownloadCubit extends MockCubit<ModDownloadState>
    implements ModDownloadCubit {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

const _downloadable = ModDownload(storageUrl: 'https://s.test/f.zip');

ModDetail mod({
  ModRef? manufacturer,
  ModRef? category,
  ModRef? country,
  List<ModSpec> specs = const [],
  String? html,
  ModMedia? media,
  ModDownload? download = _downloadable,
}) => ModDetail(
  sourceId: 7,
  type: ModType.truck,
  title: 'Big Rig',
  manufacturer: manufacturer,
  category: category,
  country: country,
  specs: specs,
  contentHtml: html,
  media: media,
  download: download,
);

ModCard card(int i) => ModCard(sourceId: i, type: ModType.bus, title: 'Rel $i');

void main() {
  late MockModDetailCubit cubit;
  late MockModDownloadCubit download;
  late MockFavoritesCubit favorites;

  setUp(() {
    cubit = MockModDetailCubit();
    download = MockModDownloadCubit();
    favorites = MockFavoritesCubit();
    when(() => cubit.load(any())).thenAnswer((_) async {});
    whenListen(
      download,
      const Stream<ModDownloadState>.empty(),
      initialState: const ModDownloadState.idle(),
    );
    whenListen(
      favorites,
      const Stream<FavoritesState>.empty(),
      initialState: const FavoritesState.success([]),
    );
  });

  Future<void> pump(WidgetTester t, ModDetailState state) async {
    whenListen(
      cubit,
      const Stream<ModDetailState>.empty(),
      initialState: state,
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => MultiBlocProvider(
            providers: [
              BlocProvider<ModDetailCubit>.value(value: cubit),
              BlocProvider<ModDownloadCubit>.value(value: download),
              BlocProvider<FavoritesCubit>.value(value: favorites),
            ],
            child: const ModDetailPage(sourceId: 7),
          ),
        ),
        GoRoute(
          path: '/mod/:sourceId',
          builder: (_, s) => Text('detail ${s.pathParameters['sourceId']}'),
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
  }

  ModDetailState ok(ModDetail m, [List<ModCard> related = const []]) =>
      ModDetailState.success(m, related);

  testWidgets('loading shows a spinner', (t) async {
    await pump(t, const ModDetailState.loading());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('failure shows mapped message and retry reloads', (t) async {
    await pump(t, const ModDetailState.failure(Failure.network()));
    expect(find.text('Retry'), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => cubit.load(7)).called(1);
  });

  testWidgets('404 shows "no longer available" and no Retry', (t) async {
    await pump(t, const ModDetailState.failure(Failure.server(code: 404)));
    expect(find.text('This mod is no longer available'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('success shows title, CTA and favorite button', (t) async {
    await pump(t, ok(mod()));
    expect(find.text('Big Rig'), findsNWidgets(2)); // app bar + headline
    expect(find.byType(DownloadCta), findsOneWidget);
    expect(find.byType(FavoriteButton), findsOneWidget);
    expect(find.byType(DetailGallery), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus_outlined), findsOneWidget);
  });

  testWidgets('chips skip null refs and show the type', (t) async {
    await pump(
      t,
      ok(
        mod(
          manufacturer: const ModRef(id: 'm', name: 'Volvo'),
          country: const ModRef(id: 'c'),
        ),
      ),
    );
    expect(find.widgetWithText(Chip, 'Truck'), findsOneWidget);
    expect(find.widgetWithText(Chip, 'Volvo'), findsOneWidget);
    expect(find.byType(Chip), findsNWidgets(2));
  });

  testWidgets('specs are grouped in first-seen order', (t) async {
    await pump(
      t,
      ok(
        mod(
          specs: const [
            ModSpec(group: 'Engine', label: 'Power', value: '400 hp'),
            ModSpec(group: 'Body', label: 'Length', value: '12 m'),
            ModSpec(group: 'Engine', label: 'Torque', value: '2000 Nm'),
          ],
        ),
      ),
    );
    expect(find.text('Specifications'), findsOneWidget);
    final engine = t.getTopLeft(find.text('Engine')).dy;
    final power = t.getTopLeft(find.text('Power')).dy;
    final torque = t.getTopLeft(find.text('Torque')).dy;
    final body = t.getTopLeft(find.text('Body')).dy;
    final length = t.getTopLeft(find.text('Length')).dy;
    expect(engine < power && power < torque && torque < body, isTrue);
    expect(body < length, isTrue);
    expect(find.text('400 hp'), findsOneWidget);
    expect(find.text('Engine'), findsOneWidget);
  });

  testWidgets('empty specs and description sections are hidden', (t) async {
    await pump(t, ok(mod(html: '   ')));
    expect(find.text('Specifications'), findsNothing);
    expect(find.text('Description'), findsNothing);
  });

  testWidgets('description is shown when present', (t) async {
    await pump(t, ok(mod(html: '<p>Nice truck</p>')));
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Nice truck', findRichText: true), findsOneWidget);
  });

  testWidgets('related title uses the manufacturer name', (t) async {
    await pump(
      t,
      ok(
        mod(
          manufacturer: const ModRef(id: 'm', name: 'Volvo'),
        ),
        [card(1)],
      ),
    );
    expect(find.text('More from Volvo'), findsOneWidget);
    expect(find.text('Rel 1'), findsOneWidget);
  });

  testWidgets('related title falls back without a manufacturer', (t) async {
    await pump(t, ok(mod(), [card(1)]));
    expect(find.text('More like this'), findsOneWidget);
  });

  testWidgets('related section hidden when empty', (t) async {
    await pump(
      t,
      ok(
        mod(
          manufacturer: const ModRef(id: 'm', name: 'Volvo'),
        ),
      ),
    );
    expect(find.textContaining('More '), findsNothing);
  });

  testWidgets('tapping a related card opens its detail', (t) async {
    await pump(t, ok(mod(), [card(42)]));
    await t.ensureVisible(find.text('Rel 42'));
    await t.tap(find.text('Rel 42'));
    await t.pumpAndSettle();
    expect(find.text('detail 42'), findsOneWidget);
  });

  testWidgets('no bottom bar when not downloadable', (t) async {
    await pump(t, ok(mod(download: null)));
    expect(find.byType(DownloadCta), findsNothing);
  });
}
