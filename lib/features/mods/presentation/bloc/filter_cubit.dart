import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/mod_type.dart';
import '../../data/repositories/mods_repository.dart';
import 'filter_state.dart';

@injectable
class FilterCubit extends Cubit<FilterState> {
  FilterCubit(this._repo) : super(const FilterState.initial());

  final ModsRepository _repo;

  Future<void> load(ModType type) async {
    emit(const FilterState.loading());
    final result = await _repo.filterOptions(type);
    if (isClosed) return;
    emit(result.fold(FilterState.failure, FilterState.success));
  }
}
