// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterOption {

@JsonKey(name: '_id') String get id; String get name; Map<String, int> get modCount;
/// Create a copy of FilterOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterOptionCopyWith<FilterOption> get copyWith => _$FilterOptionCopyWithImpl<FilterOption>(this as FilterOption, _$identity);

  /// Serializes this FilterOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.modCount, modCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(modCount));

@override
String toString() {
  return 'FilterOption(id: $id, name: $name, modCount: $modCount)';
}


}

/// @nodoc
abstract mixin class $FilterOptionCopyWith<$Res>  {
  factory $FilterOptionCopyWith(FilterOption value, $Res Function(FilterOption) _then) = _$FilterOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, Map<String, int> modCount
});




}
/// @nodoc
class _$FilterOptionCopyWithImpl<$Res>
    implements $FilterOptionCopyWith<$Res> {
  _$FilterOptionCopyWithImpl(this._self, this._then);

  final FilterOption _self;
  final $Res Function(FilterOption) _then;

/// Create a copy of FilterOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? modCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modCount: null == modCount ? _self.modCount : modCount // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterOption].
extension FilterOptionPatterns on FilterOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterOption value)  $default,){
final _that = this;
switch (_that) {
case _FilterOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterOption value)?  $default,){
final _that = this;
switch (_that) {
case _FilterOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  Map<String, int> modCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterOption() when $default != null:
return $default(_that.id,_that.name,_that.modCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  Map<String, int> modCount)  $default,) {final _that = this;
switch (_that) {
case _FilterOption():
return $default(_that.id,_that.name,_that.modCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String name,  Map<String, int> modCount)?  $default,) {final _that = this;
switch (_that) {
case _FilterOption() when $default != null:
return $default(_that.id,_that.name,_that.modCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilterOption extends FilterOption {
  const _FilterOption({@JsonKey(name: '_id') required this.id, required this.name, final  Map<String, int> modCount = const <String, int>{}}): _modCount = modCount,super._();
  factory _FilterOption.fromJson(Map<String, dynamic> json) => _$FilterOptionFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String name;
 final  Map<String, int> _modCount;
@override@JsonKey() Map<String, int> get modCount {
  if (_modCount is EqualUnmodifiableMapView) return _modCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_modCount);
}


/// Create a copy of FilterOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterOptionCopyWith<_FilterOption> get copyWith => __$FilterOptionCopyWithImpl<_FilterOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilterOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._modCount, _modCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_modCount));

@override
String toString() {
  return 'FilterOption(id: $id, name: $name, modCount: $modCount)';
}


}

/// @nodoc
abstract mixin class _$FilterOptionCopyWith<$Res> implements $FilterOptionCopyWith<$Res> {
  factory _$FilterOptionCopyWith(_FilterOption value, $Res Function(_FilterOption) _then) = __$FilterOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, Map<String, int> modCount
});




}
/// @nodoc
class __$FilterOptionCopyWithImpl<$Res>
    implements _$FilterOptionCopyWith<$Res> {
  __$FilterOptionCopyWithImpl(this._self, this._then);

  final _FilterOption _self;
  final $Res Function(_FilterOption) _then;

/// Create a copy of FilterOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? modCount = null,}) {
  return _then(_FilterOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modCount: null == modCount ? _self._modCount : modCount // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
