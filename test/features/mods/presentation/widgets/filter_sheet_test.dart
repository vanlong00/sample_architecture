import 'package:busmod/core/di/injector.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/core/l10n/app_localizations.dart';
import 'package:busmod/features/mods/data/models/filter_option.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/filter_cubit.dart';
import 'package:busmod/features/mods/presentation/widgets/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

void main() {
  late _MockRepo repo;
  ModFilter? result;
  var returned = false;

  final FilterOptions options = (
    categories: [
      const FilterOption(id: 'c1', name: 'Coach', modCount: {'bus': 5}),
      const FilterOption(id: 'c0', name: 'Hidden', modCount: {'bus': 0}),
    ],
    manufacturers: [
      const FilterOption(id: 'm1', name: 'Volvo', modCount: {'bus': 3}),
    ],
    countries: [
      const FilterOption(id: 'k1', name: 'Japan', modCount: {'bus': 2}),
    ],
  );

  setUp(() {
    repo = _MockRepo();
    result = null;
    returned = false;
    when(
      () => repo.filterOptions(ModType.bus),
    ).thenAnswer((_) async => right(options));
    getIt.registerFactory<FilterCubit>(() => FilterCubit(repo));
  });
  tearDown(() => getIt.reset());

  Future<void> open(
    WidgetTester t, {
    ModFilter current = const ModFilter(),
  }) async {
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showFilterSheet(
                context,
                type: ModType.bus,
                current: current,
              );
              returned = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await t.tap(find.text('open'));
    await t.pumpAndSettle();
  }

  testWidgets('shows options with counts, hides zero-count ones', (t) async {
    await open(t);
    expect(find.text('Coach (5)'), findsOneWidget);
    expect(find.text('Volvo (3)'), findsOneWidget);
    expect(find.text('Japan (2)'), findsOneWidget);
    expect(find.textContaining('Hidden'), findsNothing);
    expect(find.text('All'), findsNWidgets(3));
  });

  testWidgets('Apply returns the chosen filter', (t) async {
    await open(t, current: const ModFilter(countryId: 'k1'));
    await t.tap(find.text('Coach (5)'));
    await t.tap(find.text('Volvo (3)'));
    await t.pump();
    await t.tap(find.text('Apply'));
    await t.pumpAndSettle();
    expect(
      result,
      const ModFilter(categoryId: 'c1', manufacturerId: 'm1', countryId: 'k1'),
    );
  });

  testWidgets('Reset clears the selection', (t) async {
    await open(t, current: const ModFilter(categoryId: 'c1'));
    await t.tap(find.text('Reset'));
    await t.pump();
    await t.tap(find.text('Apply'));
    await t.pumpAndSettle();
    expect(result, const ModFilter());
  });

  testWidgets('dismiss returns null', (t) async {
    await open(t);
    await t.tapAt(const Offset(10, 10));
    await t.pumpAndSettle();
    expect(returned, isTrue);
    expect(result, isNull);
  });

  testWidgets('failure shows neutral message and retry reloads', (t) async {
    when(
      () => repo.filterOptions(ModType.bus),
    ).thenAnswer((_) async => left(const Failure.unknown('boom')));
    await open(t);
    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.textContaining('boom'), findsNothing);
    when(
      () => repo.filterOptions(ModType.bus),
    ).thenAnswer((_) async => right(options));
    await t.tap(find.text('Retry'));
    await t.pumpAndSettle();
    expect(find.text('Coach (5)'), findsOneWidget);
  });
}
