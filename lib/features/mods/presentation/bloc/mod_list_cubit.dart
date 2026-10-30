import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/mod_query.dart';
import '../../data/models/mod_type.dart';
import '../../data/repositories/mods_repository.dart';
import 'mod_list_state.dart';
import 'visible_page.dart';

@injectable
class ModListCubit extends Cubit<ModListState> {
  ModListCubit(this._repo, @factoryParam ModType type)
    : _query = ModQuery(type: type),
      super(const ModListState.initial());

  final ModsRepository _repo;
  ModQuery _query;

  /// Bumped on every first-page request; a response from an older request is
  /// dropped (query changed, or a newer load/refresh superseded it).
  int _gen = 0;

  /// Generation of the last first-page request that settled; `_gen != _doneGen`
  /// means a first-page request (e.g. a silent refresh) is in flight.
  int _doneGen = 0;

  Future<void> load() => _loadFirst(showLoading: true);

  /// Pull to refresh: keeps the current list on screen while reloading page 1,
  /// bypassing the HTTP cache.
  Future<void> refresh() =>
      _loadFirst(showLoading: state is! ModListSuccess, forceRefresh: true);

  Future<void> setSort(ModSort sort) {
    if (sort == _query.sort) return Future.value();
    _query = _query.copyWith(sort: sort);
    return _loadFirst(showLoading: true);
  }

  Future<void> setFilter(ModFilter filter) {
    if (filter == _query.filter) return Future.value();
    _query = _query.copyWith(filter: filter);
    return _loadFirst(showLoading: true);
  }

  Future<void> loadMore() async {
    final s = state;
    // Ignored while page 1 is being reloaded: its result would be stale.
    if (s is! ModListSuccess || !s.hasMore || s.loadingMore) return;
    if (_gen != _doneGen) return;
    final busy = s.copyWith(loadingMore: true, loadMoreFailure: null);
    emit(busy);
    final result = await fetchVisiblePage(
      (skip) => _repo.list(s.query, skip: skip),
      s.nextSkip,
    );
    // A refresh/sort/filter replaced the state meanwhile: drop the page.
    if (isClosed || !identical(state, busy)) return;
    emit(
      result.fold(
        (f) => s.copyWith(loadingMore: false, loadMoreFailure: f),
        (page) => s.copyWith(
          items: [...s.items, ...page.items],
          nextSkip: page.nextSkip,
          hasMore: page.hasMore,
          loadingMore: false,
          loadMoreFailure: null,
        ),
      ),
    );
  }

  Future<void> _loadFirst({
    required bool showLoading,
    bool forceRefresh = false,
  }) async {
    final query = _query;
    final gen = ++_gen;
    if (showLoading) emit(ModListState.loading(query));
    final result = await fetchVisiblePage(
      (skip) => forceRefresh && skip == 0
          ? _repo.list(query, skip: 0, forceRefresh: true)
          : _repo.list(query, skip: skip),
      0,
    );
    if (isClosed || gen != _gen) return;
    _doneGen = gen;
    emit(
      result.fold(
        (f) => ModListState.failure(f, query),
        (page) => ModListState.success(
          query: query,
          items: page.items,
          nextSkip: page.nextSkip,
          hasMore: page.hasMore,
        ),
      ),
    );
  }
}
