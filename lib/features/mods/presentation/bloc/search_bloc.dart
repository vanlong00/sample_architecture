import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/mod_type.dart';
import '../../data/repositories/mods_repository.dart';
import 'search_event.dart';
import 'search_state.dart';
import 'visible_page.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repo) : super(const SearchState.initial()) {
    on<SearchQueryChanged>(_onQuery, transformer: restartable());
    on<SearchTypeChanged>(_onType, transformer: restartable());
    on<SearchLoadMore>(_onLoadMore, transformer: droppable());
    on<SearchRetry>(_onRetry, transformer: restartable());
    on<SearchRefresh>(_onRefresh, transformer: restartable());
  }

  final ModsRepository _repo;

  static const debounce = Duration(milliseconds: 300);
  static const minChars = 2;

  String _query = '';
  ModType? _type;

  /// Bumped by every query/type/retry. The three handlers have separate
  /// restartable() queues, so they do not cancel each other: a result whose
  /// generation is stale is dropped instead.
  int _gen = 0;

  Future<void> _onQuery(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final gen = ++_gen;
    _query = event.query.trim();
    if (_query.length < minChars) return emit(SearchState.initial(type: _type));
    await Future<void>.delayed(debounce);
    if (emit.isDone || gen != _gen) return;
    await _search(emit, gen);
  }

  Future<void> _onType(
    SearchTypeChanged event,
    Emitter<SearchState> emit,
  ) async {
    final gen = ++_gen;
    _type = event.type;
    if (_query.length < minChars) return emit(SearchState.initial(type: _type));
    await _search(emit, gen);
  }

  Future<void> _onRetry(SearchRetry event, Emitter<SearchState> emit) async {
    if (state is! SearchFailure) return;
    await _search(emit, ++_gen);
  }

  Future<void> _onRefresh(
    SearchRefresh event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchInitial) return;
    await _search(emit, ++_gen, forceRefresh: true);
  }

  Future<void> _search(
    Emitter<SearchState> emit,
    int gen, {
    bool forceRefresh = false,
  }) async {
    final (query, type) = (_query, _type);
    emit(SearchState.loading(query: query, type: type));
    final result = await fetchVisiblePage(
      (skip) => forceRefresh && skip == 0
          ? _repo.search(query: query, type: type, skip: 0, forceRefresh: true)
          : _repo.search(query: query, type: type, skip: skip),
      0,
    );
    if (emit.isDone || gen != _gen) return;
    emit(
      result.fold(
        (f) => SearchState.failure(failure: f, query: query, type: type),
        (page) => SearchState.success(
          query: query,
          type: type,
          items: page.items,
          nextSkip: page.nextSkip,
          hasMore: page.hasMore,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final s = state;
    if (s is! SearchSuccess || !s.hasMore || s.loadingMore) return;
    final busy = s.copyWith(loadingMore: true, loadMoreFailure: null);
    emit(busy);
    final result = await fetchVisiblePage(
      (skip) => _repo.search(query: s.query, type: s.type, skip: skip),
      s.nextSkip,
    );
    // loadMore runs beside restartable query/type events: drop the page if
    // the search moved on while it was in flight.
    if (emit.isDone || !identical(state, busy)) return;
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
}
