import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_card.dart';
import '../../data/models/mod_query.dart';

part 'mod_list_state.freezed.dart';

@freezed
sealed class ModListState with _$ModListState {
  const factory ModListState.initial() = ModListInitial;
  const factory ModListState.loading(ModQuery query) = ModListLoading;
  const factory ModListState.success({
    required ModQuery query,
    required List<ModCard> items,
    required int nextSkip,
    required bool hasMore,
    @Default(false) bool loadingMore,
    Failure? loadMoreFailure,
  }) = ModListSuccess;
  const factory ModListState.failure(Failure failure, ModQuery query) =
      ModListFailure;
}
