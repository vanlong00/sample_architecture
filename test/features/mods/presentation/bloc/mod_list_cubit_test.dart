import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:busmod/core/error/failure.dart';
import 'package:busmod/features/mods/data/models/mod_card.dart';
import 'package:busmod/features/mods/data/models/mod_query.dart';
import 'package:busmod/features/mods/data/models/mod_type.dart';
import 'package:busmod/features/mods/data/repositories/mods_repository.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_cubit.dart';
import 'package:busmod/features/mods/presentation/bloc/mod_list_state.dart';
import 'package:busmod/features/mods/presentation/bloc/visible_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ModsRepository {}

ModCard card(int id) => ModCard(sourceId: id, type: ModType.bus, title: 't$id');

ModPage page(List<int> ids, {required int next, bool more = true}) =>
    (items: ids.map(card).toList(), nextSkip: next, hasMore: more);

const q = ModQuery(type: ModType.bus);
const failure = Failure.network();

void main() {
  late _MockRepo repo;

  setUpAll(() => registerFallbackValue(q));
  setUp(() => repo = _MockRepo());

  void stubList(ModQuery query, int skip, Either<Failure, ModPage> r) =>
      when(() => repo.list(query, skip: skip)).thenAnswer((_) async => r);

  ModListSuccess ok(List<int> ids, {int next = 20, bool more = true}) =>
      ModListSuccess(
        query: q,
        items: ids.map(card).toList(),
        nextSkip: next,
        hasMore: more,
      );

  blocTest<ModListCubit, ModListState>(
    'load emits loading then first page',
    setUp: () => stubList(q, 0, right(page([1, 2], next: 20))),
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) => c.load(),
    expect: () => [
      const ModListState.loading(q),
      ok([1, 2]),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'initial failure',
    setUp: () => stubList(q, 0, left(failure)),
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) => c.load(),
    expect: () => [
      const ModListState.loading(q),
      const ModListState.failure(failure, q),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'loadMore appends, advances nextSkip and stops at !hasMore',
    setUp: () {
      stubList(q, 0, right(page([1], next: 20)));
      stubList(q, 20, right(page([2], next: 40, more: false)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.loadMore();
      await c.loadMore(); // no-op: hasMore == false
    },
    expect: () => [
      const ModListState.loading(q),
      ok([1]),
      ok([1]).copyWith(loadingMore: true),
      ok([1, 2], next: 40, more: false),
    ],
    verify: (_) {
      verify(() => repo.list(q, skip: 20)).called(1);
      verifyNever(() => repo.list(q, skip: 40));
    },
  );

  test('loadMore while loadingMore is a no-op', () async {
    stubList(q, 0, right(page([1], next: 20)));
    final gate = Completer<Either<Failure, ModPage>>();
    when(() => repo.list(q, skip: 20)).thenAnswer((_) => gate.future);
    final c = ModListCubit(repo, ModType.bus);
    await c.load();
    final first = c.loadMore();
    await c.loadMore();
    gate.complete(right(page([2], next: 40)));
    await first;
    verify(() => repo.list(q, skip: 20)).called(1);
    await c.close();
  });

  blocTest<ModListCubit, ModListState>(
    'loadMore failure keeps items and sets loadMoreFailure',
    setUp: () {
      stubList(q, 0, right(page([1], next: 20)));
      stubList(q, 20, left(failure));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.loadMore();
    },
    skip: 2,
    expect: () => [
      ok([1]).copyWith(loadingMore: true),
      ok([1]).copyWith(loadMoreFailure: failure),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'setSort resets skip and re-queries with the new sort',
    setUp: () {
      const newest = ModQuery(type: ModType.bus, sort: ModSort.newest);
      stubList(q, 0, right(page([1], next: 20)));
      stubList(newest, 0, right(page([9], next: 20)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.setSort(ModSort.newest);
    },
    skip: 2,
    expect: () => [
      const ModListState.loading(
        ModQuery(type: ModType.bus, sort: ModSort.newest),
      ),
      ModListSuccess(
        query: const ModQuery(type: ModType.bus, sort: ModSort.newest),
        items: [card(9)],
        nextSkip: 20,
        hasMore: true,
      ),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'setFilter after loadMore resets to skip 0 with the new filter',
    setUp: () {
      const f = ModQuery(
        type: ModType.bus,
        filter: ModFilter(categoryId: 'c1'),
      );
      stubList(q, 0, right(page([1], next: 20)));
      stubList(q, 20, right(page([2], next: 40)));
      stubList(f, 0, right(page([7], next: 20)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.loadMore();
      await c.setFilter(const ModFilter(categoryId: 'c1'));
    },
    skip: 4,
    expect: () => [
      isA<ModListLoading>(),
      isA<ModListSuccess>()
          .having((s) => s.items.map((e) => e.sourceId), 'items', [7])
          .having((s) => s.nextSkip, 'nextSkip', 20),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'refresh reloads page 1 without a loading flash, bypassing the cache',
    setUp: () {
      stubList(q, 0, right(page([1], next: 20)));
      when(
        () => repo.list(q, skip: 0, forceRefresh: true),
      ).thenAnswer((_) async => right(page([5], next: 20)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.refresh();
    },
    skip: 2,
    expect: () => [
      ok([5]),
    ],
    verify: (_) {
      verify(() => repo.list(q, skip: 0)).called(1);
      verify(() => repo.list(q, skip: 0, forceRefresh: true)).called(1);
    },
  );

  test(
    'refresh finishing first: a slow loadMore cannot revive old list',
    () async {
      stubList(q, 0, right(page([1], next: 20)));
      final slowMore = Completer<Either<Failure, ModPage>>();
      when(() => repo.list(q, skip: 20)).thenAnswer((_) => slowMore.future);
      when(
        () => repo.list(q, skip: 0, forceRefresh: true),
      ).thenAnswer((_) async => right(page([5], next: 20)));
      final c = ModListCubit(repo, ModType.bus);
      await c.load();
      final more = c.loadMore();
      await c.refresh();
      expect((c.state as ModListSuccess).items.map((e) => e.sourceId), [5]);
      slowMore.complete(right(page([2], next: 40)));
      await more;
      final s = c.state as ModListSuccess;
      expect(s.items.map((e) => e.sourceId), [5]);
      expect(s.nextSkip, 20);
      expect(s.loadingMore, isFalse);
      await c.close();
    },
  );

  test('loadMore is ignored while a refresh is in flight', () async {
    stubList(q, 0, right(page([1], next: 20)));
    final slowRefresh = Completer<Either<Failure, ModPage>>();
    when(
      () => repo.list(q, skip: 0, forceRefresh: true),
    ).thenAnswer((_) => slowRefresh.future);
    final c = ModListCubit(repo, ModType.bus);
    await c.load();
    final refresh = c.refresh();
    await c.loadMore();
    verifyNever(() => repo.list(q, skip: 20));
    expect((c.state as ModListSuccess).loadingMore, isFalse);
    slowRefresh.complete(right(page([5], next: 20)));
    await refresh;
    expect((c.state as ModListSuccess).items.map((e) => e.sourceId), [5]);
    await c.close();
  });

  test('loadMore works again after a refresh settles', () async {
    stubList(q, 0, right(page([1], next: 20)));
    stubList(q, 20, right(page([2], next: 40)));
    when(
      () => repo.list(q, skip: 0, forceRefresh: true),
    ).thenAnswer((_) async => right(page([5], next: 20)));
    final c = ModListCubit(repo, ModType.bus);
    await c.load();
    await c.refresh();
    await c.loadMore();
    expect((c.state as ModListSuccess).items.map((e) => e.sourceId), [5, 2]);
    await c.close();
  });

  test('stale response from a replaced query is ignored', () async {
    const newest = ModQuery(type: ModType.bus, sort: ModSort.newest);
    final slow = Completer<Either<Failure, ModPage>>();
    when(() => repo.list(q, skip: 0)).thenAnswer((_) => slow.future);
    stubList(newest, 0, right(page([9], next: 20)));
    final c = ModListCubit(repo, ModType.bus);
    final first = c.load();
    await c.setSort(ModSort.newest);
    slow.complete(right(page([1], next: 20)));
    await first;
    final s = c.state as ModListSuccess;
    expect(s.query, newest);
    expect(s.items.single.sourceId, 9);
    await c.close();
  });

  blocTest<ModListCubit, ModListState>(
    'page 1 fully filtered out with hasMore -> fetches the next page',
    setUp: () {
      stubList(q, 0, right(page([], next: 20)));
      stubList(q, 20, right(page([3], next: 40)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) => c.load(),
    expect: () => [
      const ModListState.loading(q),
      ok([3], next: 40),
    ],
  );

  blocTest<ModListCubit, ModListState>(
    'loadMore page fully filtered out -> keeps going to the next page',
    setUp: () {
      stubList(q, 0, right(page([1], next: 20)));
      stubList(q, 20, right(page([], next: 40)));
      stubList(q, 40, right(page([5], next: 60, more: false)));
    },
    build: () => ModListCubit(repo, ModType.bus),
    act: (c) async {
      await c.load();
      await c.loadMore();
    },
    skip: 3,
    expect: () => [
      ok([1, 5], next: 60, more: false),
    ],
  );

  test('empty pages are bounded: stops after $maxEmptyPages fetches', () async {
    for (var i = 0; i < 10; i++) {
      stubList(q, i * 20, right(page([], next: (i + 1) * 20)));
    }
    final c = ModListCubit(repo, ModType.bus);
    await c.load();
    final s = c.state as ModListSuccess;
    expect(s.items, isEmpty);
    expect(s.hasMore, isTrue);
    expect(s.nextSkip, maxEmptyPages * 20);
    verify(() => repo.list(q, skip: any(named: 'skip'))).called(maxEmptyPages);
    await c.close();
  });
}
