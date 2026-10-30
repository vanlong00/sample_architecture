import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/search_bloc.dart';
import 'package:busmod/features/mods/presentation/bloc/search_event.dart';
import 'package:busmod/features/mods/presentation/bloc/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

ModCard card(int id) => ModCard(sourceId: id, type: ModType.bus, title: 't$id');

ModPage page(List<int> ids, {required int next, bool more = true}) =>
    (items: ids.map(card).toList(), nextSkip: next, hasMore: more);

const failure = Failure.network();
const settle = Duration(milliseconds: 400);

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  void stubSearch(
    String query,
    ModType? type,
    int skip,
    Either<Failure, ModPage> r,
  ) => when(
    () => repo.search(query: query, type: type, skip: skip),
  ).thenAnswer((_) async => r);

  SearchSuccess ok(
    String query,
    List<int> ids, {
    ModType? type,
    int next = 20,
    bool more = true,
  }) => SearchSuccess(
    query: query,
    type: type,
    items: ids.map(card).toList(),
    nextSkip: next,
    hasMore: more,
  );

  blocTest<SearchBloc, SearchState>(
    'debounce sends only the last query, exactly once',
    setUp: () => stubSearch('bus', null, 0, right(page([1], next: 20))),
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.queryChanged('bu'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      b.add(const SearchEvent.queryChanged('bus'));
    },
    wait: settle,
    expect: () => [
      const SearchState.loading(query: 'bus'),
      ok('bus', [1]),
    ],
    verify: (_) {
      verify(
        () => repo.search(
          query: any(named: 'query'),
          type: any(named: 'type'),
          skip: any(named: 'skip'),
        ),
      ).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'less than 2 chars goes back to initial keeping the type',
    setUp: () => stubSearch('bus', ModType.car, 0, right(page([1], next: 20))),
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.typeChanged(ModType.car));
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.queryChanged(' b '));
    },
    skip: 3, // initial(car), loading, success
    wait: settle,
    expect: () => [const SearchState.initial(type: ModType.car)],
  );

  blocTest<SearchBloc, SearchState>(
    'typeChanged re-queries with the new type',
    setUp: () {
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      stubSearch('bus', ModType.truck, 0, right(page([5], next: 20)));
    },
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.typeChanged(ModType.truck));
    },
    skip: 2,
    wait: settle,
    expect: () => [
      const SearchState.loading(query: 'bus', type: ModType.truck),
      ok('bus', [5], type: ModType.truck),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'loadMore appends, advances nextSkip; second one is dropped while busy',
    setUp: () {
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      stubSearch('bus', null, 20, right(page([2], next: 40, more: false)));
    },
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b
        ..add(const SearchEvent.loadMore())
        ..add(const SearchEvent.loadMore());
    },
    skip: 2,
    wait: settle,
    expect: () => [
      ok('bus', [1]).copyWith(loadingMore: true),
      ok('bus', [1, 2], next: 40, more: false),
    ],
    verify: (_) =>
        verify(() => repo.search(query: 'bus', type: null, skip: 20)).called(1),
  );

  blocTest<SearchBloc, SearchState>(
    'loadMore failure keeps items and sets loadMoreFailure',
    setUp: () {
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      stubSearch('bus', null, 20, left(failure));
    },
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.loadMore());
    },
    skip: 3,
    wait: settle,
    expect: () => [
      ok('bus', [1]).copyWith(loadMoreFailure: failure),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'failure then retry succeeds',
    setUp: () {
      var n = 0;
      when(() => repo.search(query: 'bus', type: null, skip: 0)).thenAnswer(
        (_) async => n++ == 0 ? left(failure) : right(page([1], next: 20)),
      );
    },
    build: () => SearchBloc(repo),
    act: (b) async {
      b.add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.retry());
    },
    wait: settle,
    expect: () => [
      const SearchState.loading(query: 'bus'),
      const SearchState.failure(failure: failure, query: 'bus'),
      const SearchState.loading(query: 'bus'),
      ok('bus', [1]),
    ],
  );

  test('refresh bypasses the cache; the other reads stay cached', () async {
    stubSearch('bus', null, 0, right(page([1], next: 20)));
    when(
      () => repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
    ).thenAnswer((_) async => right(page([7], next: 20)));
    final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
    await Future<void>.delayed(settle);
    expect(b.state, ok('bus', [1]));
    b.add(const SearchEvent.refresh());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(b.state, ok('bus', [7]));
    verify(() => repo.search(query: 'bus', type: null, skip: 0)).called(1);
    verify(
      () => repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
    ).called(1);
    await b.close();
  });

  test('refresh with nothing searched is a no-op', () async {
    final b = SearchBloc(repo)..add(const SearchEvent.refresh());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(b.state, const SearchState.initial());
    verifyNever(
      () => repo.search(
        query: any(named: 'query'),
        type: any(named: 'type'),
        skip: any(named: 'skip'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    );
    await b.close();
  });

  test('slow loadMore cannot overwrite a refreshed list', () async {
    stubSearch('bus', null, 0, right(page([1], next: 20)));
    final slowMore = Completer<Either<Failure, ModPage>>();
    when(
      () => repo.search(query: 'bus', type: null, skip: 20),
    ).thenAnswer((_) => slowMore.future);
    when(
      () => repo.search(query: 'bus', type: null, skip: 0, forceRefresh: true),
    ).thenAnswer((_) async => right(page([1], next: 20))); // same content
    final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
    await Future<void>.delayed(settle);
    b.add(const SearchEvent.loadMore());
    await Future<void>.delayed(Duration.zero);
    b.add(const SearchEvent.refresh());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    slowMore.complete(right(page([2], next: 40)));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(b.state, ok('bus', [1]));
    await b.close();
  });

  test('loadMore result is dropped when the query changed meanwhile', () async {
    stubSearch('bus', null, 0, right(page([1], next: 20)));
    stubSearch('car', null, 0, right(page([8], next: 20)));
    final gate = Completer<Either<Failure, ModPage>>();
    when(
      () => repo.search(query: 'bus', type: null, skip: 20),
    ).thenAnswer((_) => gate.future);
    final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
    await Future<void>.delayed(settle);
    b.add(const SearchEvent.loadMore());
    await Future<void>.delayed(Duration.zero);
    b.add(const SearchEvent.queryChanged('car'));
    await Future<void>.delayed(settle);
    gate.complete(right(page([2], next: 40)));
    await Future<void>.delayed(Duration.zero);
    expect((b.state as SearchSuccess).items.single.sourceId, 8);
    await b.close();
  });

  test(
    'slow search for the old type cannot overwrite the newer type',
    () async {
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      final slow = Completer<Either<Failure, ModPage>>();
      when(
        () => repo.search(query: 'bus', type: ModType.car, skip: 0),
      ).thenAnswer((_) => slow.future);
      stubSearch('bus', ModType.truck, 0, right(page([5], next: 20)));
      final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.typeChanged(ModType.car)); // slow, in flight
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.typeChanged(ModType.truck)); // fast, newer
      await Future<void>.delayed(const Duration(milliseconds: 50));
      slow.complete(right(page([2], next: 20)));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state, ok('bus', [5], type: ModType.truck));
      await b.close();
    },
  );

  test(
    'clearing the field while a request is in flight stays initial',
    () async {
      final slow = Completer<Either<Failure, ModPage>>();
      when(
        () => repo.search(query: 'bus', type: null, skip: 0),
      ).thenAnswer((_) => slow.future);
      final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle); // request now in flight
      b.add(const SearchEvent.queryChanged(''));
      await Future<void>.delayed(Duration.zero);
      slow.complete(right(page([2], next: 20)));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state, const SearchState.initial());
      await b.close();
    },
  );

  test(
    'clearing the field after a type change in flight stays initial',
    () async {
      final slow = Completer<Either<Failure, ModPage>>();
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      when(
        () => repo.search(query: 'bus', type: ModType.car, skip: 0),
      ).thenAnswer((_) => slow.future);
      final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      b.add(const SearchEvent.typeChanged(ModType.car));
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.queryChanged(''));
      await Future<void>.delayed(Duration.zero);
      slow.complete(right(page([2], next: 20)));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state, const SearchState.initial(type: ModType.car));
      await b.close();
    },
  );

  test(
    'fully filtered page keeps fetching until something is visible',
    () async {
      stubSearch('bus', null, 0, right(page([], next: 20)));
      stubSearch('bus', null, 20, right(page([4], next: 40)));
      final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      expect(b.state, ok('bus', [4], next: 40));
      await b.close();
    },
  );

  group('refresh keeps the list on screen', () {
    Future<SearchBloc> searched() async {
      stubSearch('bus', null, 0, right(page([1], next: 20)));
      final b = SearchBloc(repo)..add(const SearchEvent.queryChanged('bus'));
      await Future<void>.delayed(settle);
      return b;
    }

    void stubRefresh(Future<Either<Failure, ModPage>> Function() answer) =>
        when(
          () => repo.search(
            query: 'bus',
            type: null,
            skip: 0,
            forceRefresh: true,
          ),
        ).thenAnswer((_) => answer());

    test('no loading emit; completer completes null on success', () async {
      final b = await searched();
      stubRefresh(() async => right(page([7], next: 20)));
      final states = <SearchState>[];
      final sub = b.stream.listen(states.add);
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      expect(await done.future, isNull);
      expect(states, [
        ok('bus', [7]),
      ]);
      await sub.cancel();
      await b.close();
    });

    test(
      'failure keeps the old list and reports it via the completer',
      () async {
        final b = await searched();
        stubRefresh(() async => left(failure));
        final states = <SearchState>[];
        final sub = b.stream.listen(states.add);
        final done = Completer<Failure?>();
        b.add(SearchEvent.refresh(done));
        expect(await done.future, failure);
        expect(states, isEmpty);
        expect(b.state, ok('bus', [1]));
        await sub.cancel();
        await b.close();
      },
    );

    test('completer completes even when nothing was searched', () async {
      final b = SearchBloc(repo);
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      expect(await done.future, isNull);
      await b.close();
    });

    test('queryChanged during a refresh drops the stale result', () async {
      final b = await searched();
      final slow = Completer<Either<Failure, ModPage>>();
      stubRefresh(() => slow.future);
      stubSearch('car', null, 0, right(page([8], next: 20)));
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.queryChanged('car'));
      await Future<void>.delayed(settle);
      slow.complete(right(page([7], next: 20)));
      expect(await done.future, isNull);
      expect(b.state, ok('car', [8]));
      await b.close();
    });

    test('a stale refresh failure is not reported or shown', () async {
      final b = await searched();
      final slow = Completer<Either<Failure, ModPage>>();
      stubRefresh(() => slow.future);
      stubSearch('bus', ModType.truck, 0, right(page([5], next: 20)));
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.typeChanged(ModType.truck));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      slow.complete(left(failure));
      expect(await done.future, isNull);
      expect(b.state, ok('bus', [5], type: ModType.truck));
      await b.close();
    });

    test('clearing the field during a refresh stays initial', () async {
      final b = await searched();
      final slow = Completer<Either<Failure, ModPage>>();
      stubRefresh(() => slow.future);
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      await Future<void>.delayed(Duration.zero);
      b.add(const SearchEvent.queryChanged(''));
      await Future<void>.delayed(Duration.zero);
      slow.complete(right(page([7], next: 20)));
      expect(await done.future, isNull);
      expect(b.state, const SearchState.initial());
      await b.close();
    });

    test('loadMore keeps working after a refresh', () async {
      final b = await searched();
      stubRefresh(() async => right(page([7], next: 20)));
      stubSearch('bus', null, 20, right(page([8], next: 40, more: false)));
      final done = Completer<Failure?>();
      b.add(SearchEvent.refresh(done));
      await done.future;
      b.add(const SearchEvent.loadMore());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state, ok('bus', [7, 8], next: 40, more: false));
      await b.close();
    });
  });
}
