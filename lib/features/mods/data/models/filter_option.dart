import 'package:freezed_annotation/freezed_annotation.dart';

import 'mod_type.dart';

part 'filter_option.freezed.dart';
part 'filter_option.g.dart';

@freezed
abstract class FilterOption with _$FilterOption {
  const FilterOption._();

  const factory FilterOption({
    @JsonKey(name: '_id') required String id,
    required String name,
    @Default(<String, int>{}) Map<String, int> modCount,
  }) = _FilterOption;

  factory FilterOption.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionFromJson(json);

  int countFor(ModType t) => modCount[t.apiValue] ?? 0;
}
