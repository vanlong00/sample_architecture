// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDetailState()';
}


}

/// @nodoc
class $ModDetailStateCopyWith<$Res>  {
$ModDetailStateCopyWith(ModDetailState _, $Res Function(ModDetailState) __);
}


/// Adds pattern-matching-related methods to [ModDetailState].
extension ModDetailStatePatterns on ModDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ModDetailInitial value)?  initial,TResult Function( ModDetailLoading value)?  loading,TResult Function( ModDetailSuccess value)?  success,TResult Function( ModDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ModDetailInitial() when initial != null:
return initial(_that);case ModDetailLoading() when loading != null:
return loading(_that);case ModDetailSuccess() when success != null:
return success(_that);case ModDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ModDetailInitial value)  initial,required TResult Function( ModDetailLoading value)  loading,required TResult Function( ModDetailSuccess value)  success,required TResult Function( ModDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case ModDetailInitial():
return initial(_that);case ModDetailLoading():
return loading(_that);case ModDetailSuccess():
return success(_that);case ModDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ModDetailInitial value)?  initial,TResult? Function( ModDetailLoading value)?  loading,TResult? Function( ModDetailSuccess value)?  success,TResult? Function( ModDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ModDetailInitial() when initial != null:
return initial(_that);case ModDetailLoading() when loading != null:
return loading(_that);case ModDetailSuccess() when success != null:
return success(_that);case ModDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ModDetail mod,  List<ModCard> related)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ModDetailInitial() when initial != null:
return initial();case ModDetailLoading() when loading != null:
return loading();case ModDetailSuccess() when success != null:
return success(_that.mod,_that.related);case ModDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ModDetail mod,  List<ModCard> related)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case ModDetailInitial():
return initial();case ModDetailLoading():
return loading();case ModDetailSuccess():
return success(_that.mod,_that.related);case ModDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ModDetail mod,  List<ModCard> related)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case ModDetailInitial() when initial != null:
return initial();case ModDetailLoading() when loading != null:
return loading();case ModDetailSuccess() when success != null:
return success(_that.mod,_that.related);case ModDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ModDetailInitial implements ModDetailState {
  const ModDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDetailState.initial()';
}


}




/// @nodoc


class ModDetailLoading implements ModDetailState {
  const ModDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModDetailState.loading()';
}


}




/// @nodoc


class ModDetailSuccess implements ModDetailState {
  const ModDetailSuccess(this.mod, final  List<ModCard> related): _related = related;
  

 final  ModDetail mod;
 final  List<ModCard> _related;
 List<ModCard> get related {
  if (_related is EqualUnmodifiableListView) return _related;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_related);
}


/// Create a copy of ModDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDetailSuccessCopyWith<ModDetailSuccess> get copyWith => _$ModDetailSuccessCopyWithImpl<ModDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetailSuccess&&(identical(other.mod, mod) || other.mod == mod)&&const DeepCollectionEquality().equals(other._related, _related));
}


@override
int get hashCode => Object.hash(runtimeType,mod,const DeepCollectionEquality().hash(_related));

@override
String toString() {
  return 'ModDetailState.success(mod: $mod, related: $related)';
}


}

/// @nodoc
abstract mixin class $ModDetailSuccessCopyWith<$Res> implements $ModDetailStateCopyWith<$Res> {
  factory $ModDetailSuccessCopyWith(ModDetailSuccess value, $Res Function(ModDetailSuccess) _then) = _$ModDetailSuccessCopyWithImpl;
@useResult
$Res call({
 ModDetail mod, List<ModCard> related
});


$ModDetailCopyWith<$Res> get mod;

}
/// @nodoc
class _$ModDetailSuccessCopyWithImpl<$Res>
    implements $ModDetailSuccessCopyWith<$Res> {
  _$ModDetailSuccessCopyWithImpl(this._self, this._then);

  final ModDetailSuccess _self;
  final $Res Function(ModDetailSuccess) _then;

/// Create a copy of ModDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mod = null,Object? related = null,}) {
  return _then(ModDetailSuccess(
null == mod ? _self.mod : mod // ignore: cast_nullable_to_non_nullable
as ModDetail,null == related ? _self._related : related // ignore: cast_nullable_to_non_nullable
as List<ModCard>,
  ));
}

/// Create a copy of ModDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDetailCopyWith<$Res> get mod {
  
  return $ModDetailCopyWith<$Res>(_self.mod, (value) {
    return _then(_self.copyWith(mod: value));
  });
}
}

/// @nodoc


class ModDetailFailure implements ModDetailState {
  const ModDetailFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ModDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDetailFailureCopyWith<ModDetailFailure> get copyWith => _$ModDetailFailureCopyWithImpl<ModDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ModDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ModDetailFailureCopyWith<$Res> implements $ModDetailStateCopyWith<$Res> {
  factory $ModDetailFailureCopyWith(ModDetailFailure value, $Res Function(ModDetailFailure) _then) = _$ModDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ModDetailFailureCopyWithImpl<$Res>
    implements $ModDetailFailureCopyWith<$Res> {
  _$ModDetailFailureCopyWithImpl(this._self, this._then);

  final ModDetailFailure _self;
  final $Res Function(ModDetailFailure) _then;

/// Create a copy of ModDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ModDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ModDetailState
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
