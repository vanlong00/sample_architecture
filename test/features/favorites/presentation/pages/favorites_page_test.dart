import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/core/l10n/app_localizations_en.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:busmod/features/favorites/presentation/pages/favorites_page.dart';
import 'package:busmod/features/favorites/presentation/widgets/favorite_tile.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

FavoriteRecord rec(int id, {ModType type = ModType.bus}) =>
    FavoriteRecord(sourceId: id, title: 'Mod $id', type: type, savedAtMs: id);

void main() {
  late MockFavoritesCubit cubit;

  setUp(() {
    cubit = MockFavoritesCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.remove(any())).thenAnswer((_) async {});
  });

  Future<GoRouter> pump(WidgetTester t, FavoritesState state) async {
    whenListen(
      cubit,
      const Stream<FavoritesState>.empty(),
      initialState: state,
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => BlocProvider<FavoritesCubit>.value(
            value: cubit,
            child: const FavoritesPage(),
          ),
        ),
        GoRoute(
          path: '/mod/:sourceId',
          builder: (_, s) =>
              Scaffold(body: Text('detail ${s.pathParameters['sourceId']}')),
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
    return router;
  }

  testWidgets('loading shows progress; initial triggers load', (t) async {
    await pump(t, const FavoritesState.loading());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verifyNever(() => cubit.load());

    await pump(t, const FavoritesState.initial());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(() => cubit.load()).called(1);
  });

  testWidgets('empty shows favoritesEmpty', (t) async {
    await pump(t, const FavoritesState.success([]));
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.byType(FavoriteTile), findsNothing);
  });

  testWidgets('success lists tiles with localized type', (t) async {
    await pump(t, FavoritesState.success([rec(1), rec(2, type: ModType.map)]));
    expect(find.byType(FavoriteTile), findsNWidgets(2));
    expect(find.text('Mod 1'), findsOneWidget);
    expect(find.text('Bus'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
  });

  testWidgets('tap navigates to /mod/<id>', (t) async {
    await pump(t, FavoritesState.success([rec(5)]));
    await t.tap(find.text('Mod 5'));
    await t.pumpAndSettle();
    expect(find.text('detail 5'), findsOneWidget);
  });

  testWidgets('remove icon calls cubit.remove with id', (t) async {
    await pump(t, FavoritesState.success([rec(5)]));
    await t.tap(find.byTooltip('Remove Mod 5 from favorites'));
    verify(() => cubit.remove(5)).called(1);
  });

  testWidgets('failure shows localized error and retry calls load', (t) async {
    await pump(t, const FavoritesState.failure(Failure.network()));
    expect(find.text(AppLocalizationsEn().errorNetwork), findsOneWidget);
    await t.tap(find.text('Retry'));
    verify(() => cubit.load()).called(1);
  });
}
