import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/mod_card.dart';
import '../../data/models/mod_detail.dart';

part 'mod_detail_state.freezed.dart';

@freezed
sealed class ModDetailState with _$ModDetailState {
  const factory ModDetailState.initial() = ModDetailInitial;
  const factory ModDetailState.loading() = ModDetailLoading;
  const factory ModDetailState.success(ModDetail mod, List<ModCard> related) =
      ModDetailSuccess;
  const factory ModDetailState.failure(Failure failure) = ModDetailFailure;
}
