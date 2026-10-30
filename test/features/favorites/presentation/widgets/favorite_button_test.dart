import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/favorites/data/models/favorite_record.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:busmod/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:busmod/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:busmod/features/mods/data/models/mod_detail.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

const mod = ModDetail(sourceId: 7, type: ModType.truck, title: 'Volvo');

void main() {
  late MockFavoritesCubit cubit;

  setUp(() {
    cubit = MockFavoritesCubit();
    when(() => cubit.toggle(mod)).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester t, FavoritesState state) async {
    whenListen(
      cubit,
      const Stream<FavoritesState>.empty(),
      initialState: state,
    );
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: BlocProvider<FavoritesCubit>.value(
            value: cubit,
            child: const FavoriteButton(mod: mod),
          ),
        ),
      ),
    );
  }

  testWidgets('not favorite: outlined heart, add label; tap toggles', (
    t,
  ) async {
    await pump(t, const FavoritesState.success([]));
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byTooltip('Add to favorites'), findsOneWidget);
    await t.tap(find.byType(IconButton));
    verify(() => cubit.toggle(mod)).called(1);
  });

  testWidgets('favorite: filled heart, remove label, 48dp', (t) async {
    await pump(
      t,
      const FavoritesState.success([
        FavoriteRecord(
          sourceId: 7,
          title: 'Volvo',
          type: ModType.truck,
          savedAtMs: 1,
        ),
      ]),
    );
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    final size = t.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
