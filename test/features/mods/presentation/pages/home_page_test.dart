import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/filter_option.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/filter_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart';
import 'package:busmod/features/mods/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

ModCard _card(int i, ModType type) =>
    ModCard(sourceId: i, type: type, title: '${type.name} mod $i');

ModPage _page(List<ModCard> items) =>
    (items: items, nextSkip: items.length, hasMore: false);

void main() {
  late _MockRepo repo;

  setUpAll(() {
    registerFallbackValue(const ModQuery(type: ModType.bus));
    registerFallbackValue(ModType.bus);
  });

  setUp(() {
    repo = _MockRepo();
    when(() => repo.list(any(), skip: any(named: 'skip'))).thenAnswer((
      i,
    ) async {
      final q = i.positionalArguments.first as ModQuery;
      return right(_page([_card(1, q.type)]));
    });
    when(() => repo.filterOptions(any())).thenAnswer(
      (_) async => right((
        categories: [
          const FilterOption(id: 'c1', name: 'Coach', modCount: {'bus': 5}),
        ],
        manufacturers: <FilterOption>[],
        countries: <FilterOption>[],
      )),
    );
    getIt
      ..registerFactoryParam<ModListCubit, ModType, dynamic>(
        (type, _) => ModListCubit(repo, type),
      )
      ..registerFactory<FilterCubit>(() => FilterCubit(repo));
  });
  tearDown(() => getIt.reset());

  Future<void> pump(WidgetTester t) async {
    t.view.physicalSize = const Size(400, 800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
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
    await t.pumpAndSettle();
  }

  Badge badge(WidgetTester t) => t.widget<Badge>(find.byType(Badge));

  testWidgets('shows title and 4 tabs, loads bus list first', (t) async {
    await pump(t);
    expect(find.text('Home'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(TabBar), matching: find.byType(Tab)),
      findsNWidgets(4),
    );
    for (final l in ['Bus', 'Truck', 'Car', 'Map']) {
      expect(find.widgetWithText(Tab, l), findsOneWidget);
    }
    expect(find.text('bus mod 1'), findsOneWidget);
    verify(
      () => repo.list(const ModQuery(type: ModType.bus), skip: 0),
    ).called(1);
    verifyNever(() => repo.list(const ModQuery(type: ModType.truck), skip: 0));
  });

  testWidgets('switching tab creates that type list', (t) async {
    await pump(t);
    await t.tap(find.widgetWithText(Tab, 'Truck'));
    await t.pumpAndSettle();
    expect(find.text('truck mod 1'), findsOneWidget);
    verify(
      () => repo.list(const ModQuery(type: ModType.truck), skip: 0),
    ).called(1);
    // Back to bus: kept alive, not reloaded.
    await t.tap(find.widgetWithText(Tab, 'Bus'));
    await t.pumpAndSettle();
    verify(
      () => repo.list(const ModQuery(type: ModType.bus), skip: 0),
    ).called(1);
  });

  testWidgets('sort chip calls setSort', (t) async {
    await pump(t);
    await t.tap(find.text('Newest'));
    await t.pumpAndSettle();
    verify(
      () => repo.list(
        const ModQuery(type: ModType.bus, sort: ModSort.newest),
        skip: 0,
      ),
    ).called(1);
  });

  testWidgets('tapping a card navigates to detail', (t) async {
    await pump(t);
    await t.tap(find.text('bus mod 1'));
    await t.pumpAndSettle();
    expect(find.text('detail 1'), findsOneWidget);
  });

  testWidgets('failure shows neutral message and retry reloads', (t) async {
    when(
      () => repo.list(any(), skip: any(named: 'skip')),
    ).thenAnswer((_) async => left(const Failure.unknown('stack trace')));
    await pump(t);
    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.textContaining('stack trace'), findsNothing);
    await t.tap(find.text('Retry'));
    await t.pumpAndSettle();
    verify(
      () => repo.list(const ModQuery(type: ModType.bus), skip: 0),
    ).called(2);
  });

  testWidgets('filter indicator appears after applying a filter', (t) async {
    await pump(t);
    expect(badge(t).isLabelVisible, isFalse);
    await t.tap(find.text('Filters'));
    await t.pumpAndSettle();
    await t.tap(find.text('Coach (5)'));
    await t.tap(find.text('Apply'));
    await t.pumpAndSettle();
    verify(
      () => repo.list(
        const ModQuery(
          type: ModType.bus,
          filter: ModFilter(categoryId: 'c1'),
        ),
        skip: 0,
      ),
    ).called(1);
    expect(badge(t).isLabelVisible, isTrue);
    final handle = t.ensureSemantics();
    expect(find.bySemanticsLabel('Filters, active'), findsOneWidget);
    handle.dispose();
  });
}
