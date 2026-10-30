// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 ModType? get type;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'SearchState(type: $type)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 ModType? type
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchInitial value)?  initial,TResult Function( SearchLoading value)?  loading,TResult Function( SearchSuccess value)?  success,TResult Function( SearchFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchInitial value)  initial,required TResult Function( SearchLoading value)  loading,required TResult Function( SearchSuccess value)  success,required TResult Function( SearchFailure value)  failure,}){
final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that);case SearchLoading():
return loading(_that);case SearchSuccess():
return success(_that);case SearchFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchInitial value)?  initial,TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchSuccess value)?  success,TResult? Function( SearchFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ModType? type)?  initial,TResult Function( String query,  ModType? type)?  loading,TResult Function( String query,  ModType? type,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)?  success,TResult Function( Failure failure,  String query,  ModType? type)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that.type);case SearchLoading() when loading != null:
return loading(_that.query,_that.type);case SearchSuccess() when success != null:
return success(_that.query,_that.type,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case SearchFailure() when failure != null:
return failure(_that.failure,_that.query,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ModType? type)  initial,required TResult Function( String query,  ModType? type)  loading,required TResult Function( String query,  ModType? type,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)  success,required TResult Function( Failure failure,  String query,  ModType? type)  failure,}) {final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that.type);case SearchLoading():
return loading(_that.query,_that.type);case SearchSuccess():
return success(_that.query,_that.type,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case SearchFailure():
return failure(_that.failure,_that.query,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ModType? type)?  initial,TResult? Function( String query,  ModType? type)?  loading,TResult? Function( String query,  ModType? type,  List<ModCard> items,  int nextSkip,  bool hasMore,  bool loadingMore,  Failure? loadMoreFailure)?  success,TResult? Function( Failure failure,  String query,  ModType? type)?  failure,}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that.type);case SearchLoading() when loading != null:
return loading(_that.query,_that.type);case SearchSuccess() when success != null:
return success(_that.query,_that.type,_that.items,_that.nextSkip,_that.hasMore,_that.loadingMore,_that.loadMoreFailure);case SearchFailure() when failure != null:
return failure(_that.failure,_that.query,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class SearchInitial implements SearchState {
  const SearchInitial({this.type});
  

@override final  ModType? type;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchInitialCopyWith<SearchInitial> get copyWith => _$SearchInitialCopyWithImpl<SearchInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInitial&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'SearchState.initial(type: $type)';
}


}

/// @nodoc
abstract mixin class $SearchInitialCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchInitialCopyWith(SearchInitial value, $Res Function(SearchInitial) _then) = _$SearchInitialCopyWithImpl;
@override @useResult
$Res call({
 ModType? type
});




}
/// @nodoc
class _$SearchInitialCopyWithImpl<$Res>
    implements $SearchInitialCopyWith<$Res> {
  _$SearchInitialCopyWithImpl(this._self, this._then);

  final SearchInitial _self;
  final $Res Function(SearchInitial) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,}) {
  return _then(SearchInitial(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,
  ));
}


}

/// @nodoc


class SearchLoading implements SearchState {
  const SearchLoading({required this.query, this.type});
  

 final  String query;
@override final  ModType? type;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<SearchLoading> get copyWith => _$SearchLoadingCopyWithImpl<SearchLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading&&(identical(other.query, query) || other.query == query)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,query,type);

@override
String toString() {
  return 'SearchState.loading(query: $query, type: $type)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadingCopyWith(SearchLoading value, $Res Function(SearchLoading) _then) = _$SearchLoadingCopyWithImpl;
@override @useResult
$Res call({
 String query, ModType? type
});




}
/// @nodoc
class _$SearchLoadingCopyWithImpl<$Res>
    implements $SearchLoadingCopyWith<$Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading _self;
  final $Res Function(SearchLoading) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? type = freezed,}) {
  return _then(SearchLoading(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,
  ));
}


}

/// @nodoc


class SearchSuccess implements SearchState {
  const SearchSuccess({required this.query, this.type, required final  List<ModCard> items, required this.nextSkip, required this.hasMore, this.loadingMore = false, this.loadMoreFailure}): _items = items;
  

 final  String query;
@override final  ModType? type;
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

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSuccessCopyWith<SearchSuccess> get copyWith => _$SearchSuccessCopyWithImpl<SearchSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSuccess&&(identical(other.query, query) || other.query == query)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextSkip, nextSkip) || other.nextSkip == nextSkip)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,query,type,const DeepCollectionEquality().hash(_items),nextSkip,hasMore,loadingMore,loadMoreFailure);

@override
String toString() {
  return 'SearchState.success(query: $query, type: $type, items: $items, nextSkip: $nextSkip, hasMore: $hasMore, loadingMore: $loadingMore, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class $SearchSuccessCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchSuccessCopyWith(SearchSuccess value, $Res Function(SearchSuccess) _then) = _$SearchSuccessCopyWithImpl;
@override @useResult
$Res call({
 String query, ModType? type, List<ModCard> items, int nextSkip, bool hasMore, bool loadingMore, Failure? loadMoreFailure
});


$FailureCopyWith<$Res>? get loadMoreFailure;

}
/// @nodoc
class _$SearchSuccessCopyWithImpl<$Res>
    implements $SearchSuccessCopyWith<$Res> {
  _$SearchSuccessCopyWithImpl(this._self, this._then);

  final SearchSuccess _self;
  final $Res Function(SearchSuccess) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? type = freezed,Object? items = null,Object? nextSkip = null,Object? hasMore = null,Object? loadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(SearchSuccess(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ModCard>,nextSkip: null == nextSkip ? _self.nextSkip : nextSkip // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of SearchState
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


class SearchFailure implements SearchState {
  const SearchFailure({required this.failure, required this.query, this.type});
  

 final  Failure failure;
 final  String query;
@override final  ModType? type;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFailureCopyWith<SearchFailure> get copyWith => _$SearchFailureCopyWithImpl<SearchFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFailure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.query, query) || other.query == query)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,failure,query,type);

@override
String toString() {
  return 'SearchState.failure(failure: $failure, query: $query, type: $type)';
}


}

/// @nodoc
abstract mixin class $SearchFailureCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchFailureCopyWith(SearchFailure value, $Res Function(SearchFailure) _then) = _$SearchFailureCopyWithImpl;
@override @useResult
$Res call({
 Failure failure, String query, ModType? type
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SearchFailureCopyWithImpl<$Res>
    implements $SearchFailureCopyWith<$Res> {
  _$SearchFailureCopyWithImpl(this._self, this._then);

  final SearchFailure _self;
  final $Res Function(SearchFailure) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? query = null,Object? type = freezed,}) {
  return _then(SearchFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,
  ));
}

/// Create a copy of SearchState
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
