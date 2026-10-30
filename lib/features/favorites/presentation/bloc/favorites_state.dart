import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/favorite_record.dart';

part 'favorites_state.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesInitial;
  const factory FavoritesState.loading() = FavoritesLoading;
  const factory FavoritesState.success(List<FavoriteRecord> items) =
      FavoritesSuccess;
  const factory FavoritesState.failure(Failure failure) = FavoritesFailure;
}

extension FavoritesStateX on FavoritesState {
  bool isFavorite(int sourceId) => switch (this) {
    FavoritesSuccess(:final items) => items.any((r) => r.sourceId == sourceId),
    _ => false,
  };
}
