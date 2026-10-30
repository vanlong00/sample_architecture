import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../mods/data/models/mod_detail.dart';
import '../../data/models/favorite_record.dart';
import '../../data/repositories/favorites_repository.dart';
import 'favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repository) : super(const FavoritesState.initial());

  final FavoritesRepository _repository;

  List<FavoriteRecord> get _items => switch (state) {
    FavoritesSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load() async {
    emit(const FavoritesState.loading());
    final result = await _repository.list();
    emit(result.fold(FavoritesState.failure, FavoritesState.success));
  }

  /// Adds a snapshot of [mod] or removes it when already a favorite.
  Future<void> toggle(ModDetail mod) async {
    if (state.isFavorite(mod.sourceId)) return remove(mod.sourceId);
    final record = FavoriteRecord.of(
      mod,
      savedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    final previous = _items;
    emit(FavoritesState.success([record, ...previous])); // optimistic
    final result = await _repository.add(record);
    result.fold((f) => emit(FavoritesState.failure(f)), (_) {});
  }

  Future<void> remove(int sourceId) async {
    final previous = _items;
    if (!state.isFavorite(sourceId)) return;
    emit(
      FavoritesState.success([
        for (final r in previous)
          if (r.sourceId != sourceId) r,
      ]),
    );
    final result = await _repository.remove(sourceId);
    result.fold((f) => emit(FavoritesState.failure(f)), (_) {});
  }
}
