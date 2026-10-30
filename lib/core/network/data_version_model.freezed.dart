// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_version_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataVersionModel {

 int get version;
/// Create a copy of DataVersionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataVersionModelCopyWith<DataVersionModel> get copyWith => _$DataVersionModelCopyWithImpl<DataVersionModel>(this as DataVersionModel, _$identity);

  /// Serializes this DataVersionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataVersionModel&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version);

@override
String toString() {
  return 'DataVersionModel(version: $version)';
}


}

/// @nodoc
abstract mixin class $DataVersionModelCopyWith<$Res>  {
  factory $DataVersionModelCopyWith(DataVersionModel value, $Res Function(DataVersionModel) _then) = _$DataVersionModelCopyWithImpl;
@useResult
$Res call({
 int version
});




}
/// @nodoc
class _$DataVersionModelCopyWithImpl<$Res>
    implements $DataVersionModelCopyWith<$Res> {
  _$DataVersionModelCopyWithImpl(this._self, this._then);

  final DataVersionModel _self;
  final $Res Function(DataVersionModel) _then;

/// Create a copy of DataVersionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DataVersionModel].
extension DataVersionModelPatterns on DataVersionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataVersionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataVersionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataVersionModel value)  $default,){
final _that = this;
switch (_that) {
case _DataVersionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataVersionModel value)?  $default,){
final _that = this;
switch (_that) {
case _DataVersionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataVersionModel() when $default != null:
return $default(_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version)  $default,) {final _that = this;
switch (_that) {
case _DataVersionModel():
return $default(_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version)?  $default,) {final _that = this;
switch (_that) {
case _DataVersionModel() when $default != null:
return $default(_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DataVersionModel implements DataVersionModel {
  const _DataVersionModel({required this.version});
  factory _DataVersionModel.fromJson(Map<String, dynamic> json) => _$DataVersionModelFromJson(json);

@override final  int version;

/// Create a copy of DataVersionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataVersionModelCopyWith<_DataVersionModel> get copyWith => __$DataVersionModelCopyWithImpl<_DataVersionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataVersionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataVersionModel&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version);

@override
String toString() {
  return 'DataVersionModel(version: $version)';
}


}

/// @nodoc
abstract mixin class _$DataVersionModelCopyWith<$Res> implements $DataVersionModelCopyWith<$Res> {
  factory _$DataVersionModelCopyWith(_DataVersionModel value, $Res Function(_DataVersionModel) _then) = __$DataVersionModelCopyWithImpl;
@override @useResult
$Res call({
 int version
});




}
/// @nodoc
class __$DataVersionModelCopyWithImpl<$Res>
    implements _$DataVersionModelCopyWith<$Res> {
  __$DataVersionModelCopyWithImpl(this._self, this._then);

  final _DataVersionModel _self;
  final $Res Function(_DataVersionModel) _then;

/// Create a copy of DataVersionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,}) {
  return _then(_DataVersionModel(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
