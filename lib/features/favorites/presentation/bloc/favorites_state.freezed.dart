// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState()';
}


}

/// @nodoc
class $FavoritesStateCopyWith<$Res>  {
$FavoritesStateCopyWith(FavoritesState _, $Res Function(FavoritesState) __);
}


/// Adds pattern-matching-related methods to [FavoritesState].
extension FavoritesStatePatterns on FavoritesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FavoritesInitial value)?  initial,TResult Function( FavoritesLoading value)?  loading,TResult Function( FavoritesSuccess value)?  success,TResult Function( FavoritesFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FavoritesInitial() when initial != null:
return initial(_that);case FavoritesLoading() when loading != null:
return loading(_that);case FavoritesSuccess() when success != null:
return success(_that);case FavoritesFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FavoritesInitial value)  initial,required TResult Function( FavoritesLoading value)  loading,required TResult Function( FavoritesSuccess value)  success,required TResult Function( FavoritesFailure value)  failure,}){
final _that = this;
switch (_that) {
case FavoritesInitial():
return initial(_that);case FavoritesLoading():
return loading(_that);case FavoritesSuccess():
return success(_that);case FavoritesFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FavoritesInitial value)?  initial,TResult? Function( FavoritesLoading value)?  loading,TResult? Function( FavoritesSuccess value)?  success,TResult? Function( FavoritesFailure value)?  failure,}){
final _that = this;
switch (_that) {
case FavoritesInitial() when initial != null:
return initial(_that);case FavoritesLoading() when loading != null:
return loading(_that);case FavoritesSuccess() when success != null:
return success(_that);case FavoritesFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<FavoriteRecord> items)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FavoritesInitial() when initial != null:
return initial();case FavoritesLoading() when loading != null:
return loading();case FavoritesSuccess() when success != null:
return success(_that.items);case FavoritesFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<FavoriteRecord> items)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case FavoritesInitial():
return initial();case FavoritesLoading():
return loading();case FavoritesSuccess():
return success(_that.items);case FavoritesFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<FavoriteRecord> items)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case FavoritesInitial() when initial != null:
return initial();case FavoritesLoading() when loading != null:
return loading();case FavoritesSuccess() when success != null:
return success(_that.items);case FavoritesFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FavoritesInitial implements FavoritesState {
  const FavoritesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState.initial()';
}


}




/// @nodoc


class FavoritesLoading implements FavoritesState {
  const FavoritesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState.loading()';
}


}




/// @nodoc


class FavoritesSuccess implements FavoritesState {
  const FavoritesSuccess(final  List<FavoriteRecord> items): _items = items;
  

 final  List<FavoriteRecord> _items;
 List<FavoriteRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesSuccessCopyWith<FavoritesSuccess> get copyWith => _$FavoritesSuccessCopyWithImpl<FavoritesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesSuccess&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'FavoritesState.success(items: $items)';
}


}

/// @nodoc
abstract mixin class $FavoritesSuccessCopyWith<$Res> implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesSuccessCopyWith(FavoritesSuccess value, $Res Function(FavoritesSuccess) _then) = _$FavoritesSuccessCopyWithImpl;
@useResult
$Res call({
 List<FavoriteRecord> items
});




}
/// @nodoc
class _$FavoritesSuccessCopyWithImpl<$Res>
    implements $FavoritesSuccessCopyWith<$Res> {
  _$FavoritesSuccessCopyWithImpl(this._self, this._then);

  final FavoritesSuccess _self;
  final $Res Function(FavoritesSuccess) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(FavoritesSuccess(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FavoriteRecord>,
  ));
}


}

/// @nodoc


class FavoritesFailure implements FavoritesState {
  const FavoritesFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesFailureCopyWith<FavoritesFailure> get copyWith => _$FavoritesFailureCopyWithImpl<FavoritesFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FavoritesState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FavoritesFailureCopyWith<$Res> implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesFailureCopyWith(FavoritesFailure value, $Res Function(FavoritesFailure) _then) = _$FavoritesFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FavoritesFailureCopyWithImpl<$Res>
    implements $FavoritesFailureCopyWith<$Res> {
  _$FavoritesFailureCopyWithImpl(this._self, this._then);

  final FavoritesFailure _self;
  final $Res Function(FavoritesFailure) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FavoritesFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FavoritesState
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
