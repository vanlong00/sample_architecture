import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:busmod/features/mods/presentation/pages/search_page.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

ModCard card(int i) => ModCard(sourceId: i, type: ModType.bus, title: 'Mod $i');

class _MockRepo extends Mock implements ModsRepository {}

SearchState success(List<ModCard> items) => SearchState.success(
  query: 'bus',
  items: items,
  nextSkip: 20,
  hasMore: false,
);

void main() {
  late MockSearchBloc bloc;
  setUp(() => bloc = MockSearchBloc());

  Future<void> pump(WidgetTester t, SearchState state) async {
    whenListen(bloc, const Stream<SearchState>.empty(), initialState: state);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: BlocProvider<SearchBloc>.value(
              value: bloc,
              child: const SearchPage(),
            ),
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

  testWidgets('typing dispatches one queryChanged per change', (t) async {
    await pump(t, const SearchState.initial());
    await t.enterText(find.byType(TextField), 'b');
    await t.enterText(find.byType(TextField), 'bu');
    verify(() => bloc.add(const SearchEvent.queryChanged('b'))).called(1);
    verify(() => bloc.add(const SearchEvent.queryChanged('bu'))).called(1);
  });

  testWidgets('chips dispatch typeChanged and reflect state.type', (t) async {
    await pump(t, const SearchState.initial(type: ModType.truck));
    expect(
      t.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Truck')).selected,
      isTrue,
    );
    expect(
      t
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'All types'))
          .selected,
      isFalse,
    );
    await t.tap(find.text('Map'));
    verify(
      () => bloc.add(const SearchEvent.typeChanged(ModType.map)),
    ).called(1);
    await t.tap(find.text('All types'));
    verify(() => bloc.add(const SearchEvent.typeChanged(null))).called(1);
  });

  testWidgets('initial shows the prompt', (t) async {
    await pump(t, const SearchState.initial());
    expect(find.text('Search mods'), findsWidgets);
    expect(find.text('No mods found'), findsNothing);
  });

  testWidgets('loading shows progress', (t) async {
    await pump(t, const SearchState.loading(query: 'bus'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty success shows searchEmpty', (t) async {
    await pump(t, success(const []));
    expect(find.text('No mods found'), findsOneWidget);
  });

  testWidgets('success lists cards', (t) async {
    await pump(t, success([card(1), card(2)]));
    expect(find.text('Mod 1'), findsOneWidget);
    // Lazy list: later rows may be offscreen.
    expect(find.byType(ModCardTile), findsWidgets);
  });

  testWidgets('failure shows localized error and retry dispatches', (t) async {
    await pump(
      t,
      const SearchState.failure(failure: Failure.network(), query: 'bus'),
    );
    expect(find.text('No internet connection.'), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => bloc.add(const SearchEvent.retry())).called(1);
  });

  testWidgets('tapping a card navigates to /mod/<id>', (t) async {
    await pump(t, success([card(7)]));
    await t.tap(find.text('Mod 7'));
    await t.pumpAndSettle();
    expect(find.text('detail 7'), findsOneWidget);
  });

  testWidgets('clear empties the field and dispatches queryChanged("")', (
    t,
  ) async {
    await pump(t, const SearchState.initial());
    expect(find.byTooltip('Clear'), findsNothing);
    await t.enterText(find.byType(TextField), 'bus');
    await t.pump();
    await t.tap(find.byTooltip('Clear'));
    await t.pump();
    expect(t.widget<TextField>(find.byType(TextField)).controller!.text, '');
    verify(() => bloc.add(const SearchEvent.queryChanged(''))).called(1);
  });

  group('pull to refresh (real SearchBloc)', () {
    late _MockRepo repo;
    late SearchBloc real;

    ModPage pageOf(List<int> ids) =>
        (items: ids.map(card).toList(), nextSkip: 20, hasMore: false);

    void stubFirst(List<int> ids) => when(
      () => repo.search(query: 'bus', type: null, skip: 0),
    ).thenAnswer((_) async => right(pageOf(ids)));

    When<Future<Either<Failure, ModPage>>> refreshCall() => when(
      () => repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
    );

    Future<void> pumpReal(WidgetTester t) async {
      real = SearchBloc(repo);
      // Not closed: awaiting close() inside the fake-async test zone hangs.
      addTearDown(() => unawaited(real.close()));
      await t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: BlocProvider<SearchBloc>.value(
              value: real,
              child: const SearchPage(),
            ),
          ),
        ),
      );
      await t.enterText(find.byType(TextField), 'bus');
      await t.pump(SearchBloc.debounce);
      await t.pump();
    }

    Future<void> pull(WidgetTester t) async {
      await t.fling(find.byType(Scrollable).last, const Offset(0, 300), 1000);
      await t.pump();
      await t.pump(const Duration(seconds: 1));
    }

    setUp(() => repo = _MockRepo());

    testWidgets('list stays rendered while the refresh is in flight', (
      t,
    ) async {
      stubFirst([1, 2]);
      await pumpReal(t);
      expect(find.text('Mod 1'), findsOneWidget);
      final gate = Completer<Either<Failure, ModPage>>();
      refreshCall().thenAnswer((_) => gate.future);

      await pull(t);
      verify(
        () =>
            repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
      ).called(1);
      expect(real.state, isA<SearchSuccess>()); // no SearchLoading
      expect(find.text('Mod 1'), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);

      gate.complete(right(pageOf([3])));
      await t.pumpAndSettle();
      expect(find.text('Mod 3'), findsOneWidget);
      expect(find.text('Mod 1'), findsNothing);
      // The indicator completed: nothing is spinning any more.
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });

    testWidgets('refresh failure keeps the items and shows a snackbar', (
      t,
    ) async {
      stubFirst([1]);
      await pumpReal(t);
      refreshCall().thenAnswer((_) async => left(const Failure.network()));

      await pull(t);
      await t.pumpAndSettle();
      expect(find.text('Mod 1'), findsOneWidget);
      expect(find.text('No internet connection.'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });

    testWidgets('a query change during a refresh wins over its result', (
      t,
    ) async {
      stubFirst([1]);
      await pumpReal(t);
      final gate = Completer<Either<Failure, ModPage>>();
      refreshCall().thenAnswer((_) => gate.future);
      when(
        () => repo.search(query: 'car', type: null, skip: 0),
      ).thenAnswer((_) async => right(pageOf([9])));

      await pull(t);
      await t.enterText(find.byType(TextField), 'car');
      await t.pump(SearchBloc.debounce);
      await t.pump();
      gate.complete(right(pageOf([5])));
      await t.pumpAndSettle();
      expect(find.text('Mod 9'), findsOneWidget);
      expect(find.text('Mod 5'), findsNothing);
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });

    testWidgets('empty result supports pull to refresh', (t) async {
      stubFirst([]);
      await pumpReal(t);
      expect(find.text('No mods found'), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      refreshCall().thenAnswer((_) async => right(pageOf([4])));

      await pull(t);
      await t.pumpAndSettle();
      verify(
        () =>
            repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
      ).called(1);
      expect(find.text('Mod 4'), findsOneWidget);
    });
  });
}
