// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FilterState()';
}


}

/// @nodoc
class $FilterStateCopyWith<$Res>  {
$FilterStateCopyWith(FilterState _, $Res Function(FilterState) __);
}


/// Adds pattern-matching-related methods to [FilterState].
extension FilterStatePatterns on FilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FilterInitial value)?  initial,TResult Function( FilterLoading value)?  loading,TResult Function( FilterSuccess value)?  success,TResult Function( FilterFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FilterInitial() when initial != null:
return initial(_that);case FilterLoading() when loading != null:
return loading(_that);case FilterSuccess() when success != null:
return success(_that);case FilterFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FilterInitial value)  initial,required TResult Function( FilterLoading value)  loading,required TResult Function( FilterSuccess value)  success,required TResult Function( FilterFailure value)  failure,}){
final _that = this;
switch (_that) {
case FilterInitial():
return initial(_that);case FilterLoading():
return loading(_that);case FilterSuccess():
return success(_that);case FilterFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FilterInitial value)?  initial,TResult? Function( FilterLoading value)?  loading,TResult? Function( FilterSuccess value)?  success,TResult? Function( FilterFailure value)?  failure,}){
final _that = this;
switch (_that) {
case FilterInitial() when initial != null:
return initial(_that);case FilterLoading() when loading != null:
return loading(_that);case FilterSuccess() when success != null:
return success(_that);case FilterFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( FilterOptions options)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FilterInitial() when initial != null:
return initial();case FilterLoading() when loading != null:
return loading();case FilterSuccess() when success != null:
return success(_that.options);case FilterFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( FilterOptions options)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case FilterInitial():
return initial();case FilterLoading():
return loading();case FilterSuccess():
return success(_that.options);case FilterFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( FilterOptions options)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case FilterInitial() when initial != null:
return initial();case FilterLoading() when loading != null:
return loading();case FilterSuccess() when success != null:
return success(_that.options);case FilterFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FilterInitial implements FilterState {
  const FilterInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FilterState.initial()';
}


}




/// @nodoc


class FilterLoading implements FilterState {
  const FilterLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FilterState.loading()';
}


}




/// @nodoc


class FilterSuccess implements FilterState {
  const FilterSuccess(this.options);
  

 final  FilterOptions options;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterSuccessCopyWith<FilterSuccess> get copyWith => _$FilterSuccessCopyWithImpl<FilterSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterSuccess&&(identical(other.options, options) || other.options == options));
}


@override
int get hashCode => Object.hash(runtimeType,options);

@override
String toString() {
  return 'FilterState.success(options: $options)';
}


}

/// @nodoc
abstract mixin class $FilterSuccessCopyWith<$Res> implements $FilterStateCopyWith<$Res> {
  factory $FilterSuccessCopyWith(FilterSuccess value, $Res Function(FilterSuccess) _then) = _$FilterSuccessCopyWithImpl;
@useResult
$Res call({
 FilterOptions options
});




}
/// @nodoc
class _$FilterSuccessCopyWithImpl<$Res>
    implements $FilterSuccessCopyWith<$Res> {
  _$FilterSuccessCopyWithImpl(this._self, this._then);

  final FilterSuccess _self;
  final $Res Function(FilterSuccess) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? options = null,}) {
  return _then(FilterSuccess(
null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as FilterOptions,
  ));
}


}

/// @nodoc


class FilterFailure implements FilterState {
  const FilterFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterFailureCopyWith<FilterFailure> get copyWith => _$FilterFailureCopyWithImpl<FilterFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FilterState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FilterFailureCopyWith<$Res> implements $FilterStateCopyWith<$Res> {
  factory $FilterFailureCopyWith(FilterFailure value, $Res Function(FilterFailure) _then) = _$FilterFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FilterFailureCopyWithImpl<$Res>
    implements $FilterFailureCopyWith<$Res> {
  _$FilterFailureCopyWithImpl(this._self, this._then);

  final FilterFailure _self;
  final $Res Function(FilterFailure) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FilterFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FilterState
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
