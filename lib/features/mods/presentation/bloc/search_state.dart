import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_card.dart';
import '../../data/models/mod_type.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.initial({ModType? type}) = SearchInitial;
  const factory SearchState.loading({required String query, ModType? type}) =
      SearchLoading;
  const factory SearchState.success({
    required String query,
    ModType? type,
    required List<ModCard> items,
    required int nextSkip,
    required bool hasMore,
    @Default(false) bool loadingMore,
    Failure? loadMoreFailure,
  }) = SearchSuccess;
  const factory SearchState.failure({
    required Failure failure,
    required String query,
    ModType? type,
  }) = SearchFailure;
}
