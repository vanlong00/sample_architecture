// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'articles_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArticlesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticlesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArticlesState()';
}


}

/// @nodoc
class $ArticlesStateCopyWith<$Res>  {
$ArticlesStateCopyWith(ArticlesState _, $Res Function(ArticlesState) __);
}


/// Adds pattern-matching-related methods to [ArticlesState].
extension ArticlesStatePatterns on ArticlesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ArticlesInitial value)?  initial,TResult Function( ArticlesLoading value)?  loading,TResult Function( ArticlesSuccess value)?  success,TResult Function( ArticlesFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ArticlesInitial() when initial != null:
return initial(_that);case ArticlesLoading() when loading != null:
return loading(_that);case ArticlesSuccess() when success != null:
return success(_that);case ArticlesFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ArticlesInitial value)  initial,required TResult Function( ArticlesLoading value)  loading,required TResult Function( ArticlesSuccess value)  success,required TResult Function( ArticlesFailure value)  failure,}){
final _that = this;
switch (_that) {
case ArticlesInitial():
return initial(_that);case ArticlesLoading():
return loading(_that);case ArticlesSuccess():
return success(_that);case ArticlesFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ArticlesInitial value)?  initial,TResult? Function( ArticlesLoading value)?  loading,TResult? Function( ArticlesSuccess value)?  success,TResult? Function( ArticlesFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ArticlesInitial() when initial != null:
return initial(_that);case ArticlesLoading() when loading != null:
return loading(_that);case ArticlesSuccess() when success != null:
return success(_that);case ArticlesFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Article> items)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ArticlesInitial() when initial != null:
return initial();case ArticlesLoading() when loading != null:
return loading();case ArticlesSuccess() when success != null:
return success(_that.items);case ArticlesFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Article> items)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case ArticlesInitial():
return initial();case ArticlesLoading():
return loading();case ArticlesSuccess():
return success(_that.items);case ArticlesFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Article> items)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case ArticlesInitial() when initial != null:
return initial();case ArticlesLoading() when loading != null:
return loading();case ArticlesSuccess() when success != null:
return success(_that.items);case ArticlesFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ArticlesInitial implements ArticlesState {
  const ArticlesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticlesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArticlesState.initial()';
}


}




/// @nodoc


class ArticlesLoading implements ArticlesState {
  const ArticlesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticlesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArticlesState.loading()';
}


}




/// @nodoc


class ArticlesSuccess implements ArticlesState {
  const ArticlesSuccess(final  List<Article> items): _items = items;
  

 final  List<Article> _items;
 List<Article> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ArticlesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticlesSuccessCopyWith<ArticlesSuccess> get copyWith => _$ArticlesSuccessCopyWithImpl<ArticlesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticlesSuccess&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ArticlesState.success(items: $items)';
}


}

/// @nodoc
abstract mixin class $ArticlesSuccessCopyWith<$Res> implements $ArticlesStateCopyWith<$Res> {
  factory $ArticlesSuccessCopyWith(ArticlesSuccess value, $Res Function(ArticlesSuccess) _then) = _$ArticlesSuccessCopyWithImpl;
@useResult
$Res call({
 List<Article> items
});




}
/// @nodoc
class _$ArticlesSuccessCopyWithImpl<$Res>
    implements $ArticlesSuccessCopyWith<$Res> {
  _$ArticlesSuccessCopyWithImpl(this._self, this._then);

  final ArticlesSuccess _self;
  final $Res Function(ArticlesSuccess) _then;

/// Create a copy of ArticlesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(ArticlesSuccess(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Article>,
  ));
}


}

/// @nodoc


class ArticlesFailure implements ArticlesState {
  const ArticlesFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ArticlesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticlesFailureCopyWith<ArticlesFailure> get copyWith => _$ArticlesFailureCopyWithImpl<ArticlesFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticlesFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ArticlesState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ArticlesFailureCopyWith<$Res> implements $ArticlesStateCopyWith<$Res> {
  factory $ArticlesFailureCopyWith(ArticlesFailure value, $Res Function(ArticlesFailure) _then) = _$ArticlesFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ArticlesFailureCopyWithImpl<$Res>
    implements $ArticlesFailureCopyWith<$Res> {
  _$ArticlesFailureCopyWithImpl(this._self, this._then);

  final ArticlesFailure _self;
  final $Res Function(ArticlesFailure) _then;

/// Create a copy of ArticlesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ArticlesFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ArticlesState
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
