// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_download_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModDownloadState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDownloadState()';
}


}

/// @nodoc
class $ModDownloadStateCopyWith<$Res>  {
$ModDownloadStateCopyWith(ModDownloadState _, $Res Function(ModDownloadState) __);
}


/// Adds pattern-matching-related methods to [ModDownloadState].
extension ModDownloadStatePatterns on ModDownloadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ModDownloadChecking value)?  checking,TResult Function( ModDownloadIdle value)?  idle,TResult Function( ModDownloadDownloading value)?  downloading,TResult Function( ModDownloadDownloaded value)?  downloaded,TResult Function( ModDownloadFileMissing value)?  fileMissing,TResult Function( ModDownloadFailure value)?  failure,TResult Function( ModDownloadCheckFailure value)?  checkFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ModDownloadChecking() when checking != null:
return checking(_that);case ModDownloadIdle() when idle != null:
return idle(_that);case ModDownloadDownloading() when downloading != null:
return downloading(_that);case ModDownloadDownloaded() when downloaded != null:
return downloaded(_that);case ModDownloadFileMissing() when fileMissing != null:
return fileMissing(_that);case ModDownloadFailure() when failure != null:
return failure(_that);case ModDownloadCheckFailure() when checkFailure != null:
return checkFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ModDownloadChecking value)  checking,required TResult Function( ModDownloadIdle value)  idle,required TResult Function( ModDownloadDownloading value)  downloading,required TResult Function( ModDownloadDownloaded value)  downloaded,required TResult Function( ModDownloadFileMissing value)  fileMissing,required TResult Function( ModDownloadFailure value)  failure,required TResult Function( ModDownloadCheckFailure value)  checkFailure,}){
final _that = this;
switch (_that) {
case ModDownloadChecking():
return checking(_that);case ModDownloadIdle():
return idle(_that);case ModDownloadDownloading():
return downloading(_that);case ModDownloadDownloaded():
return downloaded(_that);case ModDownloadFileMissing():
return fileMissing(_that);case ModDownloadFailure():
return failure(_that);case ModDownloadCheckFailure():
return checkFailure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ModDownloadChecking value)?  checking,TResult? Function( ModDownloadIdle value)?  idle,TResult? Function( ModDownloadDownloading value)?  downloading,TResult? Function( ModDownloadDownloaded value)?  downloaded,TResult? Function( ModDownloadFileMissing value)?  fileMissing,TResult? Function( ModDownloadFailure value)?  failure,TResult? Function( ModDownloadCheckFailure value)?  checkFailure,}){
final _that = this;
switch (_that) {
case ModDownloadChecking() when checking != null:
return checking(_that);case ModDownloadIdle() when idle != null:
return idle(_that);case ModDownloadDownloading() when downloading != null:
return downloading(_that);case ModDownloadDownloaded() when downloaded != null:
return downloaded(_that);case ModDownloadFileMissing() when fileMissing != null:
return fileMissing(_that);case ModDownloadFailure() when failure != null:
return failure(_that);case ModDownloadCheckFailure() when checkFailure != null:
return checkFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function()?  idle,TResult Function( int received,  int total)?  downloading,TResult Function( ModDownloadRecord record)?  downloaded,TResult Function( ModDownloadRecord record)?  fileMissing,TResult Function( Failure failure,  ModDownloadRecord? previous)?  failure,TResult Function( Failure failure)?  checkFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ModDownloadChecking() when checking != null:
return checking();case ModDownloadIdle() when idle != null:
return idle();case ModDownloadDownloading() when downloading != null:
return downloading(_that.received,_that.total);case ModDownloadDownloaded() when downloaded != null:
return downloaded(_that.record);case ModDownloadFileMissing() when fileMissing != null:
return fileMissing(_that.record);case ModDownloadFailure() when failure != null:
return failure(_that.failure,_that.previous);case ModDownloadCheckFailure() when checkFailure != null:
return checkFailure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function()  idle,required TResult Function( int received,  int total)  downloading,required TResult Function( ModDownloadRecord record)  downloaded,required TResult Function( ModDownloadRecord record)  fileMissing,required TResult Function( Failure failure,  ModDownloadRecord? previous)  failure,required TResult Function( Failure failure)  checkFailure,}) {final _that = this;
switch (_that) {
case ModDownloadChecking():
return checking();case ModDownloadIdle():
return idle();case ModDownloadDownloading():
return downloading(_that.received,_that.total);case ModDownloadDownloaded():
return downloaded(_that.record);case ModDownloadFileMissing():
return fileMissing(_that.record);case ModDownloadFailure():
return failure(_that.failure,_that.previous);case ModDownloadCheckFailure():
return checkFailure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function()?  idle,TResult? Function( int received,  int total)?  downloading,TResult? Function( ModDownloadRecord record)?  downloaded,TResult? Function( ModDownloadRecord record)?  fileMissing,TResult? Function( Failure failure,  ModDownloadRecord? previous)?  failure,TResult? Function( Failure failure)?  checkFailure,}) {final _that = this;
switch (_that) {
case ModDownloadChecking() when checking != null:
return checking();case ModDownloadIdle() when idle != null:
return idle();case ModDownloadDownloading() when downloading != null:
return downloading(_that.received,_that.total);case ModDownloadDownloaded() when downloaded != null:
return downloaded(_that.record);case ModDownloadFileMissing() when fileMissing != null:
return fileMissing(_that.record);case ModDownloadFailure() when failure != null:
return failure(_that.failure,_that.previous);case ModDownloadCheckFailure() when checkFailure != null:
return checkFailure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ModDownloadChecking implements ModDownloadState {
  const ModDownloadChecking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDownloadState.checking()';
}


}




/// @nodoc


class ModDownloadIdle implements ModDownloadState {
  const ModDownloadIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDownloadState.idle()';
}


}




/// @nodoc


class ModDownloadDownloading implements ModDownloadState {
  const ModDownloadDownloading({required this.received, required this.total});
  

 final  int received;
 final  int total;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadDownloadingCopyWith<ModDownloadDownloading> get copyWith => _$ModDownloadDownloadingCopyWithImpl<ModDownloadDownloading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadDownloading&&(identical(other.received, received) || other.received == received)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,received,total);

@override
String toString() {
  return 'ModDownloadState.downloading(received: $received, total: $total)';
}


}

/// @nodoc
abstract mixin class $ModDownloadDownloadingCopyWith<$Res> implements $ModDownloadStateCopyWith<$Res> {
  factory $ModDownloadDownloadingCopyWith(ModDownloadDownloading value, $Res Function(ModDownloadDownloading) _then) = _$ModDownloadDownloadingCopyWithImpl;
@useResult
$Res call({
 int received, int total
});




}
/// @nodoc
class _$ModDownloadDownloadingCopyWithImpl<$Res>
    implements $ModDownloadDownloadingCopyWith<$Res> {
  _$ModDownloadDownloadingCopyWithImpl(this._self, this._then);

  final ModDownloadDownloading _self;
  final $Res Function(ModDownloadDownloading) _then;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? received = null,Object? total = null,}) {
  return _then(ModDownloadDownloading(
received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ModDownloadDownloaded implements ModDownloadState {
  const ModDownloadDownloaded(this.record);
  

 final  ModDownloadRecord record;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadDownloadedCopyWith<ModDownloadDownloaded> get copyWith => _$ModDownloadDownloadedCopyWithImpl<ModDownloadDownloaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadDownloaded&&(identical(other.record, record) || other.record == record));
}


@override
int get hashCode => Object.hash(runtimeType,record);

@override
String toString() {
  return 'ModDownloadState.downloaded(record: $record)';
}


}

/// @nodoc
abstract mixin class $ModDownloadDownloadedCopyWith<$Res> implements $ModDownloadStateCopyWith<$Res> {
  factory $ModDownloadDownloadedCopyWith(ModDownloadDownloaded value, $Res Function(ModDownloadDownloaded) _then) = _$ModDownloadDownloadedCopyWithImpl;
@useResult
$Res call({
 ModDownloadRecord record
});


$ModDownloadRecordCopyWith<$Res> get record;

}
/// @nodoc
class _$ModDownloadDownloadedCopyWithImpl<$Res>
    implements $ModDownloadDownloadedCopyWith<$Res> {
  _$ModDownloadDownloadedCopyWithImpl(this._self, this._then);

  final ModDownloadDownloaded _self;
  final $Res Function(ModDownloadDownloaded) _then;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? record = null,}) {
  return _then(ModDownloadDownloaded(
null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as ModDownloadRecord,
  ));
}

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDownloadRecordCopyWith<$Res> get record {
  
  return $ModDownloadRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

/// @nodoc


class ModDownloadFileMissing implements ModDownloadState {
  const ModDownloadFileMissing(this.record);
  

 final  ModDownloadRecord record;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadFileMissingCopyWith<ModDownloadFileMissing> get copyWith => _$ModDownloadFileMissingCopyWithImpl<ModDownloadFileMissing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadFileMissing&&(identical(other.record, record) || other.record == record));
}


@override
int get hashCode => Object.hash(runtimeType,record);

@override
String toString() {
  return 'ModDownloadState.fileMissing(record: $record)';
}


}

/// @nodoc
abstract mixin class $ModDownloadFileMissingCopyWith<$Res> implements $ModDownloadStateCopyWith<$Res> {
  factory $ModDownloadFileMissingCopyWith(ModDownloadFileMissing value, $Res Function(ModDownloadFileMissing) _then) = _$ModDownloadFileMissingCopyWithImpl;
@useResult
$Res call({
 ModDownloadRecord record
});


$ModDownloadRecordCopyWith<$Res> get record;

}
/// @nodoc
class _$ModDownloadFileMissingCopyWithImpl<$Res>
    implements $ModDownloadFileMissingCopyWith<$Res> {
  _$ModDownloadFileMissingCopyWithImpl(this._self, this._then);

  final ModDownloadFileMissing _self;
  final $Res Function(ModDownloadFileMissing) _then;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? record = null,}) {
  return _then(ModDownloadFileMissing(
null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as ModDownloadRecord,
  ));
}

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDownloadRecordCopyWith<$Res> get record {
  
  return $ModDownloadRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

/// @nodoc


class ModDownloadFailure implements ModDownloadState {
  const ModDownloadFailure(this.failure, [this.previous]);
  

 final  Failure failure;
 final  ModDownloadRecord? previous;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadFailureCopyWith<ModDownloadFailure> get copyWith => _$ModDownloadFailureCopyWithImpl<ModDownloadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadFailure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.previous, previous) || other.previous == previous));
}


@override
int get hashCode => Object.hash(runtimeType,failure,previous);

@override
String toString() {
  return 'ModDownloadState.failure(failure: $failure, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $ModDownloadFailureCopyWith<$Res> implements $ModDownloadStateCopyWith<$Res> {
  factory $ModDownloadFailureCopyWith(ModDownloadFailure value, $Res Function(ModDownloadFailure) _then) = _$ModDownloadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure, ModDownloadRecord? previous
});


$FailureCopyWith<$Res> get failure;$ModDownloadRecordCopyWith<$Res>? get previous;

}
/// @nodoc
class _$ModDownloadFailureCopyWithImpl<$Res>
    implements $ModDownloadFailureCopyWith<$Res> {
  _$ModDownloadFailureCopyWithImpl(this._self, this._then);

  final ModDownloadFailure _self;
  final $Res Function(ModDownloadFailure) _then;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? previous = freezed,}) {
  return _then(ModDownloadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as ModDownloadRecord?,
  ));
}

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDownloadRecordCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $ModDownloadRecordCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

/// @nodoc


class ModDownloadCheckFailure implements ModDownloadState {
  const ModDownloadCheckFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadCheckFailureCopyWith<ModDownloadCheckFailure> get copyWith => _$ModDownloadCheckFailureCopyWithImpl<ModDownloadCheckFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownloadCheckFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ModDownloadState.checkFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ModDownloadCheckFailureCopyWith<$Res> implements $ModDownloadStateCopyWith<$Res> {
  factory $ModDownloadCheckFailureCopyWith(ModDownloadCheckFailure value, $Res Function(ModDownloadCheckFailure) _then) = _$ModDownloadCheckFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ModDownloadCheckFailureCopyWithImpl<$Res>
    implements $ModDownloadCheckFailureCopyWith<$Res> {
  _$ModDownloadCheckFailureCopyWithImpl(this._self, this._then);

  final ModDownloadCheckFailure _self;
  final $Res Function(ModDownloadCheckFailure) _then;

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ModDownloadCheckFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ModDownloadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
