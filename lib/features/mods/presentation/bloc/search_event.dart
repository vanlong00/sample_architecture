import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/mod_type.dart';

part 'search_event.freezed.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.queryChanged(String query) = SearchQueryChanged;
  const factory SearchEvent.typeChanged(ModType? type) = SearchTypeChanged;
  const factory SearchEvent.loadMore() = SearchLoadMore;
  const factory SearchEvent.retry() = SearchRetry;

  /// Pull to refresh: re-runs the current search bypassing the HTTP cache.
  const factory SearchEvent.refresh() = SearchRefresh;
}
