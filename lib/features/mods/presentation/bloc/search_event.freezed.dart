// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent()';
}


}

/// @nodoc
class $SearchEventCopyWith<$Res>  {
$SearchEventCopyWith(SearchEvent _, $Res Function(SearchEvent) __);
}


/// Adds pattern-matching-related methods to [SearchEvent].
extension SearchEventPatterns on SearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchQueryChanged value)?  queryChanged,TResult Function( SearchTypeChanged value)?  typeChanged,TResult Function( SearchLoadMore value)?  loadMore,TResult Function( SearchRetry value)?  retry,TResult Function( SearchRefresh value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case SearchTypeChanged() when typeChanged != null:
return typeChanged(_that);case SearchLoadMore() when loadMore != null:
return loadMore(_that);case SearchRetry() when retry != null:
return retry(_that);case SearchRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchQueryChanged value)  queryChanged,required TResult Function( SearchTypeChanged value)  typeChanged,required TResult Function( SearchLoadMore value)  loadMore,required TResult Function( SearchRetry value)  retry,required TResult Function( SearchRefresh value)  refresh,}){
final _that = this;
switch (_that) {
case SearchQueryChanged():
return queryChanged(_that);case SearchTypeChanged():
return typeChanged(_that);case SearchLoadMore():
return loadMore(_that);case SearchRetry():
return retry(_that);case SearchRefresh():
return refresh(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchQueryChanged value)?  queryChanged,TResult? Function( SearchTypeChanged value)?  typeChanged,TResult? Function( SearchLoadMore value)?  loadMore,TResult? Function( SearchRetry value)?  retry,TResult? Function( SearchRefresh value)?  refresh,}){
final _that = this;
switch (_that) {
case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case SearchTypeChanged() when typeChanged != null:
return typeChanged(_that);case SearchLoadMore() when loadMore != null:
return loadMore(_that);case SearchRetry() when retry != null:
return retry(_that);case SearchRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String query)?  queryChanged,TResult Function( ModType? type)?  typeChanged,TResult Function()?  loadMore,TResult Function()?  retry,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case SearchTypeChanged() when typeChanged != null:
return typeChanged(_that.type);case SearchLoadMore() when loadMore != null:
return loadMore();case SearchRetry() when retry != null:
return retry();case SearchRefresh() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String query)  queryChanged,required TResult Function( ModType? type)  typeChanged,required TResult Function()  loadMore,required TResult Function()  retry,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case SearchQueryChanged():
return queryChanged(_that.query);case SearchTypeChanged():
return typeChanged(_that.type);case SearchLoadMore():
return loadMore();case SearchRetry():
return retry();case SearchRefresh():
return refresh();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String query)?  queryChanged,TResult? Function( ModType? type)?  typeChanged,TResult? Function()?  loadMore,TResult? Function()?  retry,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case SearchTypeChanged() when typeChanged != null:
return typeChanged(_that.type);case SearchLoadMore() when loadMore != null:
return loadMore();case SearchRetry() when retry != null:
return retry();case SearchRefresh() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class SearchQueryChanged implements SearchEvent {
  const SearchQueryChanged(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchQueryChangedCopyWith<SearchQueryChanged> get copyWith => _$SearchQueryChangedCopyWithImpl<SearchQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchQueryChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchQueryChangedCopyWith(SearchQueryChanged value, $Res Function(SearchQueryChanged) _then) = _$SearchQueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchQueryChangedCopyWithImpl<$Res>
    implements $SearchQueryChangedCopyWith<$Res> {
  _$SearchQueryChangedCopyWithImpl(this._self, this._then);

  final SearchQueryChanged _self;
  final $Res Function(SearchQueryChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchQueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchTypeChanged implements SearchEvent {
  const SearchTypeChanged(this.type);
  

 final  ModType? type;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTypeChangedCopyWith<SearchTypeChanged> get copyWith => _$SearchTypeChangedCopyWithImpl<SearchTypeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTypeChanged&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'SearchEvent.typeChanged(type: $type)';
}


}

/// @nodoc
abstract mixin class $SearchTypeChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchTypeChangedCopyWith(SearchTypeChanged value, $Res Function(SearchTypeChanged) _then) = _$SearchTypeChangedCopyWithImpl;
@useResult
$Res call({
 ModType? type
});




}
/// @nodoc
class _$SearchTypeChangedCopyWithImpl<$Res>
    implements $SearchTypeChangedCopyWith<$Res> {
  _$SearchTypeChangedCopyWithImpl(this._self, this._then);

  final SearchTypeChanged _self;
  final $Res Function(SearchTypeChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = freezed,}) {
  return _then(SearchTypeChanged(
freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType?,
  ));
}


}

/// @nodoc


class SearchLoadMore implements SearchEvent {
  const SearchLoadMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoadMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.loadMore()';
}


}




/// @nodoc


class SearchRetry implements SearchEvent {
  const SearchRetry();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRetry);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.retry()';
}


}




/// @nodoc


class SearchRefresh implements SearchEvent {
  const SearchRefresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRefresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.refresh()';
}


}




// dart format on
