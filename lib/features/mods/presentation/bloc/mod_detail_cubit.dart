import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/mod_card.dart';
import '../../data/repositories/mods_repository.dart';
import 'mod_detail_state.dart';

@injectable
class ModDetailCubit extends Cubit<ModDetailState> {
  ModDetailCubit(this._repo) : super(const ModDetailState.initial());

  final ModsRepository _repo;

  Future<void> load(int sourceId) async {
    emit(const ModDetailState.loading());
    final (detail, related) = await (
      _repo.detail(sourceId),
      _repo.related(sourceId),
    ).wait;
    if (isClosed) return;
    emit(
      detail.fold(
        ModDetailState.failure,
        // Related is optional: a failing call just hides the section.
        (mod) => ModDetailState.success(
          mod,
          related.getOrElse((_) => const <ModCard>[]),
        ),
      ),
    );
  }
}
