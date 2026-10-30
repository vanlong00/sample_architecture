import 'package:freezed_annotation/freezed_annotation.dart';

import 'mod_type.dart';

part 'mod_query.freezed.dart';

@freezed
abstract class ModFilter with _$ModFilter {
  const factory ModFilter({
    String? categoryId,
    String? manufacturerId,
    String? countryId,
  }) = _ModFilter;
}

@freezed
abstract class ModQuery with _$ModQuery {
  const factory ModQuery({
    required ModType type,
    @Default(ModSort.popular) ModSort sort,
    @Default(ModFilter()) ModFilter filter,
  }) = _ModQuery;
}
