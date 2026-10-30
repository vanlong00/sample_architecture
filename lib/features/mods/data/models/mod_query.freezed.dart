// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModFilter {

 String? get categoryId; String? get manufacturerId; String? get countryId;
/// Create a copy of ModFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModFilterCopyWith<ModFilter> get copyWith => _$ModFilterCopyWithImpl<ModFilter>(this as ModFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModFilter&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.countryId, countryId) || other.countryId == countryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,manufacturerId,countryId);

@override
String toString() {
  return 'ModFilter(categoryId: $categoryId, manufacturerId: $manufacturerId, countryId: $countryId)';
}


}

/// @nodoc
abstract mixin class $ModFilterCopyWith<$Res>  {
  factory $ModFilterCopyWith(ModFilter value, $Res Function(ModFilter) _then) = _$ModFilterCopyWithImpl;
@useResult
$Res call({
 String? categoryId, String? manufacturerId, String? countryId
});




}
/// @nodoc
class _$ModFilterCopyWithImpl<$Res>
    implements $ModFilterCopyWith<$Res> {
  _$ModFilterCopyWithImpl(this._self, this._then);

  final ModFilter _self;
  final $Res Function(ModFilter) _then;

/// Create a copy of ModFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? manufacturerId = freezed,Object? countryId = freezed,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModFilter].
extension ModFilterPatterns on ModFilter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModFilter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModFilter value)  $default,){
final _that = this;
switch (_that) {
case _ModFilter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ModFilter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? categoryId,  String? manufacturerId,  String? countryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModFilter() when $default != null:
return $default(_that.categoryId,_that.manufacturerId,_that.countryId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? categoryId,  String? manufacturerId,  String? countryId)  $default,) {final _that = this;
switch (_that) {
case _ModFilter():
return $default(_that.categoryId,_that.manufacturerId,_that.countryId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? categoryId,  String? manufacturerId,  String? countryId)?  $default,) {final _that = this;
switch (_that) {
case _ModFilter() when $default != null:
return $default(_that.categoryId,_that.manufacturerId,_that.countryId);case _:
  return null;

}
}

}

/// @nodoc


class _ModFilter implements ModFilter {
  const _ModFilter({this.categoryId, this.manufacturerId, this.countryId});
  

@override final  String? categoryId;
@override final  String? manufacturerId;
@override final  String? countryId;

/// Create a copy of ModFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModFilterCopyWith<_ModFilter> get copyWith => __$ModFilterCopyWithImpl<_ModFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModFilter&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.countryId, countryId) || other.countryId == countryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,manufacturerId,countryId);

@override
String toString() {
  return 'ModFilter(categoryId: $categoryId, manufacturerId: $manufacturerId, countryId: $countryId)';
}


}

/// @nodoc
abstract mixin class _$ModFilterCopyWith<$Res> implements $ModFilterCopyWith<$Res> {
  factory _$ModFilterCopyWith(_ModFilter value, $Res Function(_ModFilter) _then) = __$ModFilterCopyWithImpl;
@override @useResult
$Res call({
 String? categoryId, String? manufacturerId, String? countryId
});




}
/// @nodoc
class __$ModFilterCopyWithImpl<$Res>
    implements _$ModFilterCopyWith<$Res> {
  __$ModFilterCopyWithImpl(this._self, this._then);

  final _ModFilter _self;
  final $Res Function(_ModFilter) _then;

/// Create a copy of ModFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? manufacturerId = freezed,Object? countryId = freezed,}) {
  return _then(_ModFilter(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ModQuery {

 ModType get type; ModSort get sort; ModFilter get filter;
/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModQueryCopyWith<ModQuery> get copyWith => _$ModQueryCopyWithImpl<ModQuery>(this as ModQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModQuery&&(identical(other.type, type) || other.type == type)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,type,sort,filter);

@override
String toString() {
  return 'ModQuery(type: $type, sort: $sort, filter: $filter)';
}


}

/// @nodoc
abstract mixin class $ModQueryCopyWith<$Res>  {
  factory $ModQueryCopyWith(ModQuery value, $Res Function(ModQuery) _then) = _$ModQueryCopyWithImpl;
@useResult
$Res call({
 ModType type, ModSort sort, ModFilter filter
});


$ModFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$ModQueryCopyWithImpl<$Res>
    implements $ModQueryCopyWith<$Res> {
  _$ModQueryCopyWithImpl(this._self, this._then);

  final ModQuery _self;
  final $Res Function(ModQuery) _then;

/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? sort = null,Object? filter = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ModSort,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ModFilter,
  ));
}
/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModFilterCopyWith<$Res> get filter {
  
  return $ModFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModQuery].
extension ModQueryPatterns on ModQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModQuery value)  $default,){
final _that = this;
switch (_that) {
case _ModQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModQuery value)?  $default,){
final _that = this;
switch (_that) {
case _ModQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModType type,  ModSort sort,  ModFilter filter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModQuery() when $default != null:
return $default(_that.type,_that.sort,_that.filter);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModType type,  ModSort sort,  ModFilter filter)  $default,) {final _that = this;
switch (_that) {
case _ModQuery():
return $default(_that.type,_that.sort,_that.filter);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModType type,  ModSort sort,  ModFilter filter)?  $default,) {final _that = this;
switch (_that) {
case _ModQuery() when $default != null:
return $default(_that.type,_that.sort,_that.filter);case _:
  return null;

}
}

}

/// @nodoc


class _ModQuery implements ModQuery {
  const _ModQuery({required this.type, this.sort = ModSort.popular, this.filter = const ModFilter()});
  

@override final  ModType type;
@override@JsonKey() final  ModSort sort;
@override@JsonKey() final  ModFilter filter;

/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModQueryCopyWith<_ModQuery> get copyWith => __$ModQueryCopyWithImpl<_ModQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModQuery&&(identical(other.type, type) || other.type == type)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,type,sort,filter);

@override
String toString() {
  return 'ModQuery(type: $type, sort: $sort, filter: $filter)';
}


}

/// @nodoc
abstract mixin class _$ModQueryCopyWith<$Res> implements $ModQueryCopyWith<$Res> {
  factory _$ModQueryCopyWith(_ModQuery value, $Res Function(_ModQuery) _then) = __$ModQueryCopyWithImpl;
@override @useResult
$Res call({
 ModType type, ModSort sort, ModFilter filter
});


@override $ModFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$ModQueryCopyWithImpl<$Res>
    implements _$ModQueryCopyWith<$Res> {
  __$ModQueryCopyWithImpl(this._self, this._then);

  final _ModQuery _self;
  final $Res Function(_ModQuery) _then;

/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? sort = null,Object? filter = null,}) {
  return _then(_ModQuery(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ModSort,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ModFilter,
  ));
}

/// Create a copy of ModQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModFilterCopyWith<$Res> get filter {
  
  return $ModFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
