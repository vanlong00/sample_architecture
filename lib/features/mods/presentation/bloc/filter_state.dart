import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/repositories/mods_repository.dart';

part 'filter_state.freezed.dart';

@freezed
sealed class FilterState with _$FilterState {
  const factory FilterState.initial() = FilterInitial;
  const factory FilterState.loading() = FilterLoading;
  const factory FilterState.success(FilterOptions options) = FilterSuccess;
  const factory FilterState.failure(Failure failure) = FilterFailure;
}
