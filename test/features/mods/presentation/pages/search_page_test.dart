import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:busmod/features/mods/presentation/pages/search_page.dart';
import 'package:busmod/features/mods/presentation/widgets/mod_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

ModCard card(int i) => ModCard(sourceId: i, type: ModType.bus, title: 'Mod $i');

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
}
