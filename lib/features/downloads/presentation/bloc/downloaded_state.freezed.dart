// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadedState()';
}


}

/// @nodoc
class $DownloadedStateCopyWith<$Res>  {
$DownloadedStateCopyWith(DownloadedState _, $Res Function(DownloadedState) __);
}


/// Adds pattern-matching-related methods to [DownloadedState].
extension DownloadedStatePatterns on DownloadedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DownloadedInitial value)?  initial,TResult Function( DownloadedLoading value)?  loading,TResult Function( DownloadedSuccess value)?  success,TResult Function( DownloadedFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DownloadedInitial() when initial != null:
return initial(_that);case DownloadedLoading() when loading != null:
return loading(_that);case DownloadedSuccess() when success != null:
return success(_that);case DownloadedFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DownloadedInitial value)  initial,required TResult Function( DownloadedLoading value)  loading,required TResult Function( DownloadedSuccess value)  success,required TResult Function( DownloadedFailure value)  failure,}){
final _that = this;
switch (_that) {
case DownloadedInitial():
return initial(_that);case DownloadedLoading():
return loading(_that);case DownloadedSuccess():
return success(_that);case DownloadedFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DownloadedInitial value)?  initial,TResult? Function( DownloadedLoading value)?  loading,TResult? Function( DownloadedSuccess value)?  success,TResult? Function( DownloadedFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DownloadedInitial() when initial != null:
return initial(_that);case DownloadedLoading() when loading != null:
return loading(_that);case DownloadedSuccess() when success != null:
return success(_that);case DownloadedFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ModDownloadRecord> records,  int totalBytes,  Set<int> missingIds)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DownloadedInitial() when initial != null:
return initial();case DownloadedLoading() when loading != null:
return loading();case DownloadedSuccess() when success != null:
return success(_that.records,_that.totalBytes,_that.missingIds);case DownloadedFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ModDownloadRecord> records,  int totalBytes,  Set<int> missingIds)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DownloadedInitial():
return initial();case DownloadedLoading():
return loading();case DownloadedSuccess():
return success(_that.records,_that.totalBytes,_that.missingIds);case DownloadedFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ModDownloadRecord> records,  int totalBytes,  Set<int> missingIds)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DownloadedInitial() when initial != null:
return initial();case DownloadedLoading() when loading != null:
return loading();case DownloadedSuccess() when success != null:
return success(_that.records,_that.totalBytes,_that.missingIds);case DownloadedFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DownloadedInitial implements DownloadedState {
  const DownloadedInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadedState.initial()';
}


}




/// @nodoc


class DownloadedLoading implements DownloadedState {
  const DownloadedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadedState.loading()';
}


}




/// @nodoc


class DownloadedSuccess implements DownloadedState {
  const DownloadedSuccess({required final  List<ModDownloadRecord> records, required this.totalBytes, final  Set<int> missingIds = const <int>{}}): _records = records,_missingIds = missingIds;
  

 final  List<ModDownloadRecord> _records;
 List<ModDownloadRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

 final  int totalBytes;
/// Records whose file was found missing when importing.
 final  Set<int> _missingIds;
/// Records whose file was found missing when importing.
@JsonKey() Set<int> get missingIds {
  if (_missingIds is EqualUnmodifiableSetView) return _missingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_missingIds);
}


/// Create a copy of DownloadedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedSuccessCopyWith<DownloadedSuccess> get copyWith => _$DownloadedSuccessCopyWithImpl<DownloadedSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedSuccess&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&const DeepCollectionEquality().equals(other._missingIds, _missingIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),totalBytes,const DeepCollectionEquality().hash(_missingIds));

@override
String toString() {
  return 'DownloadedState.success(records: $records, totalBytes: $totalBytes, missingIds: $missingIds)';
}


}

/// @nodoc
abstract mixin class $DownloadedSuccessCopyWith<$Res> implements $DownloadedStateCopyWith<$Res> {
  factory $DownloadedSuccessCopyWith(DownloadedSuccess value, $Res Function(DownloadedSuccess) _then) = _$DownloadedSuccessCopyWithImpl;
@useResult
$Res call({
 List<ModDownloadRecord> records, int totalBytes, Set<int> missingIds
});




}
/// @nodoc
class _$DownloadedSuccessCopyWithImpl<$Res>
    implements $DownloadedSuccessCopyWith<$Res> {
  _$DownloadedSuccessCopyWithImpl(this._self, this._then);

  final DownloadedSuccess _self;
  final $Res Function(DownloadedSuccess) _then;

/// Create a copy of DownloadedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? records = null,Object? totalBytes = null,Object? missingIds = null,}) {
  return _then(DownloadedSuccess(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<ModDownloadRecord>,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,missingIds: null == missingIds ? _self._missingIds : missingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

/// @nodoc


class DownloadedFailure implements DownloadedState {
  const DownloadedFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of DownloadedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedFailureCopyWith<DownloadedFailure> get copyWith => _$DownloadedFailureCopyWithImpl<DownloadedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DownloadedState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DownloadedFailureCopyWith<$Res> implements $DownloadedStateCopyWith<$Res> {
  factory $DownloadedFailureCopyWith(DownloadedFailure value, $Res Function(DownloadedFailure) _then) = _$DownloadedFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DownloadedFailureCopyWithImpl<$Res>
    implements $DownloadedFailureCopyWith<$Res> {
  _$DownloadedFailureCopyWithImpl(this._self, this._then);

  final DownloadedFailure _self;
  final $Res Function(DownloadedFailure) _then;

/// Create a copy of DownloadedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DownloadedFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DownloadedState
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
