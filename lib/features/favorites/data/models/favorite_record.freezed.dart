// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteRecord {

 int get sourceId; String get title; String? get thumbUrl; ModType get type; int get savedAtMs;
/// Create a copy of FavoriteRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteRecordCopyWith<FavoriteRecord> get copyWith => _$FavoriteRecordCopyWithImpl<FavoriteRecord>(this as FavoriteRecord, _$identity);

  /// Serializes this FavoriteRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteRecord&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.savedAtMs, savedAtMs) || other.savedAtMs == savedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,title,thumbUrl,type,savedAtMs);

@override
String toString() {
  return 'FavoriteRecord(sourceId: $sourceId, title: $title, thumbUrl: $thumbUrl, type: $type, savedAtMs: $savedAtMs)';
}


}

/// @nodoc
abstract mixin class $FavoriteRecordCopyWith<$Res>  {
  factory $FavoriteRecordCopyWith(FavoriteRecord value, $Res Function(FavoriteRecord) _then) = _$FavoriteRecordCopyWithImpl;
@useResult
$Res call({
 int sourceId, String title, String? thumbUrl, ModType type, int savedAtMs
});




}
/// @nodoc
class _$FavoriteRecordCopyWithImpl<$Res>
    implements $FavoriteRecordCopyWith<$Res> {
  _$FavoriteRecordCopyWithImpl(this._self, this._then);

  final FavoriteRecord _self;
  final $Res Function(FavoriteRecord) _then;

/// Create a copy of FavoriteRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? title = null,Object? thumbUrl = freezed,Object? type = null,Object? savedAtMs = null,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,savedAtMs: null == savedAtMs ? _self.savedAtMs : savedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteRecord].
extension FavoriteRecordPatterns on FavoriteRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteRecord value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  int savedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteRecord() when $default != null:
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.savedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  int savedAtMs)  $default,) {final _that = this;
switch (_that) {
case _FavoriteRecord():
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.savedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  int savedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteRecord() when $default != null:
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.savedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteRecord implements FavoriteRecord {
  const _FavoriteRecord({required this.sourceId, required this.title, this.thumbUrl, required this.type, required this.savedAtMs});
  factory _FavoriteRecord.fromJson(Map<String, dynamic> json) => _$FavoriteRecordFromJson(json);

@override final  int sourceId;
@override final  String title;
@override final  String? thumbUrl;
@override final  ModType type;
@override final  int savedAtMs;

/// Create a copy of FavoriteRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteRecordCopyWith<_FavoriteRecord> get copyWith => __$FavoriteRecordCopyWithImpl<_FavoriteRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteRecord&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.savedAtMs, savedAtMs) || other.savedAtMs == savedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,title,thumbUrl,type,savedAtMs);

@override
String toString() {
  return 'FavoriteRecord(sourceId: $sourceId, title: $title, thumbUrl: $thumbUrl, type: $type, savedAtMs: $savedAtMs)';
}


}

/// @nodoc
abstract mixin class _$FavoriteRecordCopyWith<$Res> implements $FavoriteRecordCopyWith<$Res> {
  factory _$FavoriteRecordCopyWith(_FavoriteRecord value, $Res Function(_FavoriteRecord) _then) = __$FavoriteRecordCopyWithImpl;
@override @useResult
$Res call({
 int sourceId, String title, String? thumbUrl, ModType type, int savedAtMs
});




}
/// @nodoc
class __$FavoriteRecordCopyWithImpl<$Res>
    implements _$FavoriteRecordCopyWith<$Res> {
  __$FavoriteRecordCopyWithImpl(this._self, this._then);

  final _FavoriteRecord _self;
  final $Res Function(_FavoriteRecord) _then;

/// Create a copy of FavoriteRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? title = null,Object? thumbUrl = freezed,Object? type = null,Object? savedAtMs = null,}) {
  return _then(_FavoriteRecord(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,savedAtMs: null == savedAtMs ? _self.savedAtMs : savedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
