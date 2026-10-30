// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_download_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModDownloadRecord {

 int get sourceId; String get title; String? get thumbUrl; ModType get type; String get relPath; int get sizeBytes; int get createdAtMs;
/// Create a copy of ModDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadRecordCopyWith<ModDownloadRecord> get copyWith => _$ModDownloadRecordCopyWithImpl<ModDownloadRecord>(this as ModDownloadRecord, _$identity);

  /// Serializes this ModDownloadRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadRecord&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,title,thumbUrl,type,relPath,sizeBytes,createdAtMs);

@override
String toString() {
  return 'ModDownloadRecord(sourceId: $sourceId, title: $title, thumbUrl: $thumbUrl, type: $type, relPath: $relPath, sizeBytes: $sizeBytes, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class $ModDownloadRecordCopyWith<$Res>  {
  factory $ModDownloadRecordCopyWith(ModDownloadRecord value, $Res Function(ModDownloadRecord) _then) = _$ModDownloadRecordCopyWithImpl;
@useResult
$Res call({
 int sourceId, String title, String? thumbUrl, ModType type, String relPath, int sizeBytes, int createdAtMs
});




}
/// @nodoc
class _$ModDownloadRecordCopyWithImpl<$Res>
    implements $ModDownloadRecordCopyWith<$Res> {
  _$ModDownloadRecordCopyWithImpl(this._self, this._then);

  final ModDownloadRecord _self;
  final $Res Function(ModDownloadRecord) _then;

/// Create a copy of ModDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? title = null,Object? thumbUrl = freezed,Object? type = null,Object? relPath = null,Object? sizeBytes = null,Object? createdAtMs = null,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,relPath: null == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ModDownloadRecord].
extension ModDownloadRecordPatterns on ModDownloadRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModDownloadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModDownloadRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModDownloadRecord value)  $default,){
final _that = this;
switch (_that) {
case _ModDownloadRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModDownloadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ModDownloadRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  String relPath,  int sizeBytes,  int createdAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModDownloadRecord() when $default != null:
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.relPath,_that.sizeBytes,_that.createdAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  String relPath,  int sizeBytes,  int createdAtMs)  $default,) {final _that = this;
switch (_that) {
case _ModDownloadRecord():
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.relPath,_that.sizeBytes,_that.createdAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sourceId,  String title,  String? thumbUrl,  ModType type,  String relPath,  int sizeBytes,  int createdAtMs)?  $default,) {final _that = this;
switch (_that) {
case _ModDownloadRecord() when $default != null:
return $default(_that.sourceId,_that.title,_that.thumbUrl,_that.type,_that.relPath,_that.sizeBytes,_that.createdAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModDownloadRecord implements ModDownloadRecord {
  const _ModDownloadRecord({required this.sourceId, required this.title, this.thumbUrl, required this.type, required this.relPath, required this.sizeBytes, required this.createdAtMs});
  factory _ModDownloadRecord.fromJson(Map<String, dynamic> json) => _$ModDownloadRecordFromJson(json);

@override final  int sourceId;
@override final  String title;
@override final  String? thumbUrl;
@override final  ModType type;
@override final  String relPath;
@override final  int sizeBytes;
@override final  int createdAtMs;

/// Create a copy of ModDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModDownloadRecordCopyWith<_ModDownloadRecord> get copyWith => __$ModDownloadRecordCopyWithImpl<_ModDownloadRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModDownloadRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModDownloadRecord&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,title,thumbUrl,type,relPath,sizeBytes,createdAtMs);

@override
String toString() {
  return 'ModDownloadRecord(sourceId: $sourceId, title: $title, thumbUrl: $thumbUrl, type: $type, relPath: $relPath, sizeBytes: $sizeBytes, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class _$ModDownloadRecordCopyWith<$Res> implements $ModDownloadRecordCopyWith<$Res> {
  factory _$ModDownloadRecordCopyWith(_ModDownloadRecord value, $Res Function(_ModDownloadRecord) _then) = __$ModDownloadRecordCopyWithImpl;
@override @useResult
$Res call({
 int sourceId, String title, String? thumbUrl, ModType type, String relPath, int sizeBytes, int createdAtMs
});




}
/// @nodoc
class __$ModDownloadRecordCopyWithImpl<$Res>
    implements _$ModDownloadRecordCopyWith<$Res> {
  __$ModDownloadRecordCopyWithImpl(this._self, this._then);

  final _ModDownloadRecord _self;
  final $Res Function(_ModDownloadRecord) _then;

/// Create a copy of ModDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? title = null,Object? thumbUrl = freezed,Object? type = null,Object? relPath = null,Object? sizeBytes = null,Object? createdAtMs = null,}) {
  return _then(_ModDownloadRecord(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,relPath: null == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
