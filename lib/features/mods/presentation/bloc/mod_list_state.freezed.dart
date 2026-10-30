// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModListState()';
}


}

/// @nodoc
class $ModListStateCopyWith<$Res>  {
$ModListStateCopyWith(ModListState _, $Res Function(ModListState) __);
}


/// Adds pattern-matching-related methods to [ModListState].
extension ModListStatePatterns on ModListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ModListInitial value)?  initial,TResult Function( ModListLoading value)?  loading,TResult Function( ModListSuccess value)?  success,TResult Function( ModListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ModListInitial() when initial != null:
return initial(_that);case ModListLoading() when loading != null:
return loading(_that);case ModListSuccess() when success != null:
return success(_that);case ModListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ModListInitial value)  initial,required TResult Function( ModListLoading value)  loading,required TResult Function( ModListSuccess value)  success,required TResult Function( ModListFailure value)  failure,}){
final _that = this;
switch (_that) {
case ModListInitial():
return initial(_that);case ModListLoading():
return loading(_that);case ModListSuccess():
return success(_that);case ModListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ModListInitial value)?  initial,TResult? Function( ModListLoading value)?  loading,TResult? Function( ModListSuccess value)?  success,TResult? Function( ModListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ModListInitial() when initial != null:
return initial(_that);case ModListLoading() when loading != null:
return loading(_that);case ModListSuccess() when success != null:
return success(_that);case ModListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ModQuery query)?  loading,TResult Function( ModQuery query,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)?  success,TResult Function( Failure failure,  ModQuery query)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ModListInitial() when initial != null:
return initial();case ModListLoading() when loading != null:
return loading(_that.query);case ModListSuccess() when success != null:
return success(_that.query,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case ModListFailure() when failure != null:
return failure(_that.failure,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ModQuery query)  loading,required TResult Function( ModQuery query,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)  success,required TResult Function( Failure failure,  ModQuery query)  failure,}) {final _that = this;
switch (_that) {
case ModListInitial():
return initial();case ModListLoading():
return loading(_that.query);case ModListSuccess():
return success(_that.query,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case ModListFailure():
return failure(_that.failure,_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ModQuery query)?  loading,TResult? Function( ModQuery query,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)?  success,TResult? Function( Failure failure,  ModQuery query)?  failure,}) {final _that = this;
switch (_that) {
case ModListInitial() when initial != null:
return initial();case ModListLoading() when loading != null:
return loading(_that.query);case ModListSuccess() when success != null:
return success(_that.query,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case ModListFailure() when failure != null:
return failure(_that.failure,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class ModListInitial implements ModListState {
  const ModListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModListState.initial()';
}


}




/// @nodoc


class ModListLoading implements ModListState {
  const ModListLoading(this.query);
  

 final  ModQuery query;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModListLoadingCopyWith<ModListLoading> get copyWith => _$ModListLoadingCopyWithImpl<ModListLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModListLoading&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'ModListState.loading(query: $query)';
}


}

/// @nodoc
abstract mixin class $ModListLoadingCopyWith<$Res> implements $ModListStateCopyWith<$Res> {
  factory $ModListLoadingCopyWith(ModListLoading value, $Res Function(ModListLoading) _then) = _$ModListLoadingCopyWithImpl;
@useResult
$Res call({
 ModQuery query
});


$ModQueryCopyWith<$Res> get query;

}
/// @nodoc
class _$ModListLoadingCopyWithImpl<$Res>
    implements $ModListLoadingCopyWith<$Res> {
  _$ModListLoadingCopyWithImpl(this._self, this._then);

  final ModListLoading _self;
  final $Res Function(ModListLoading) _then;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(ModListLoading(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as ModQuery,
  ));
}

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModQueryCopyWith<$Res> get query {
  
  return $ModQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}

/// @nodoc


class ModListSuccess implements ModListState {
  const ModListSuccess({required this.query, required final  List<ModCard> items, required this.nextSkip, required this.hasMore, this.loadingMore = false, this.loadMoreFailure}): _items = items;
  

 final  ModQuery query;
 final  List<ModCard> _items;
 List<ModCard> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int nextSkip;
 final  bool hasMore;
@JsonKey() final  bool loadingMore;
 final  Failure? loadMoreFailure;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModListSuccessCopyWith<ModListSuccess> get copyWith => _$ModListSuccessCopyWithImpl<ModListSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModListSuccess&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextSkip, nextSkip) || other.nextSkip == nextSkip)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_items),nextSkip,hasMore,loadingMore,loadMoreFailure);

@override
String toString() {
  return 'ModListState.success(query: $query, items: $items, nextSkip: $nextSkip, hasMore: $hasMore, loadingMore: $loadingMore, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class $ModListSuccessCopyWith<$Res> implements $ModListStateCopyWith<$Res> {
  factory $ModListSuccessCopyWith(ModListSuccess value, $Res Function(ModListSuccess) _then) = _$ModListSuccessCopyWithImpl;
@useResult
$Res call({
 ModQuery query, List<ModCard> items, int nextSkip, bool hasMore, bool loadingMore, Failure? loadMoreFailure
});


$ModQueryCopyWith<$Res> get query;$FailureCopyWith<$Res>? get loadMoreFailure;

}
/// @nodoc
class _$ModListSuccessCopyWithImpl<$Res>
    implements $ModListSuccessCopyWith<$Res> {
  _$ModListSuccessCopyWithImpl(this._self, this._then);

  final ModListSuccess _self;
  final $Res Function(ModListSuccess) _then;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? items = null,Object? nextSkip = null,Object? hasMore = null,Object? loadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(ModListSuccess(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as ModQuery,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ModCard>,nextSkip: null == nextSkip ? _self.nextSkip : nextSkip // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModQueryCopyWith<$Res> get query {
  
  return $ModQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadMoreFailure {
    if (_self.loadMoreFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadMoreFailure!, (value) {
    return _then(_self.copyWith(loadMoreFailure: value));
  });
}
}

/// @nodoc


class ModListFailure implements ModListState {
  const ModListFailure(this.failure, this.query);
  

 final  Failure failure;
 final  ModQuery query;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModListFailureCopyWith<ModListFailure> get copyWith => _$ModListFailureCopyWithImpl<ModListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModListFailure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,failure,query);

@override
String toString() {
  return 'ModListState.failure(failure: $failure, query: $query)';
}


}

/// @nodoc
abstract mixin class $ModListFailureCopyWith<$Res> implements $ModListStateCopyWith<$Res> {
  factory $ModListFailureCopyWith(ModListFailure value, $Res Function(ModListFailure) _then) = _$ModListFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure, ModQuery query
});


$FailureCopyWith<$Res> get failure;$ModQueryCopyWith<$Res> get query;

}
/// @nodoc
class _$ModListFailureCopyWithImpl<$Res>
    implements $ModListFailureCopyWith<$Res> {
  _$ModListFailureCopyWithImpl(this._self, this._then);

  final ModListFailure _self;
  final $Res Function(ModListFailure) _then;

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? query = null,}) {
  return _then(ModListFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as ModQuery,
  ));
}

/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of ModListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModQueryCopyWith<$Res> get query {
  
  return $ModQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}

// dart format on
