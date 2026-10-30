import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_type.dart';

part 'search_event.freezed.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.queryChanged(String query) = SearchQueryChanged;
  const factory SearchEvent.typeChanged(ModType? type) = SearchTypeChanged;
  const factory SearchEvent.loadMore() = SearchLoadMore;
  const factory SearchEvent.retry() = SearchRetry;

  /// Pull to refresh: re-runs the current search bypassing the HTTP cache.
  /// The visible list stays on screen meanwhile. [done] (optional) completes
  /// once the refresh settles: with the [Failure] if it failed while the old
  /// list stayed visible, otherwise null (success, or superseded by a newer
  /// query/type/refresh).
  const factory SearchEvent.refresh([Completer<Failure?>? done]) =
      SearchRefresh;
}
