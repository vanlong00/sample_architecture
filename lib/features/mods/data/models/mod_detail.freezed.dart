// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModDetail {

 int get sourceId; ModType get type; String get title; ModMedia? get media; ModDownload? get download; ModRef? get manufacturer; ModRef? get category; ModRef? get country; ModStats? get stats; List<ModSpec> get specs; String? get contentHtml;
/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDetailCopyWith<ModDetail> get copyWith => _$ModDetailCopyWithImpl<ModDetail>(this as ModDetail, _$identity);

  /// Serializes this ModDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDetail&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.download, download) || other.download == download)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.specs, specs)&&(identical(other.contentHtml, contentHtml) || other.contentHtml == contentHtml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,type,title,media,download,manufacturer,category,country,stats,const DeepCollectionEquality().hash(specs),contentHtml);

@override
String toString() {
  return 'ModDetail(sourceId: $sourceId, type: $type, title: $title, media: $media, download: $download, manufacturer: $manufacturer, category: $category, country: $country, stats: $stats, specs: $specs, contentHtml: $contentHtml)';
}


}

/// @nodoc
abstract mixin class $ModDetailCopyWith<$Res>  {
  factory $ModDetailCopyWith(ModDetail value, $Res Function(ModDetail) _then) = _$ModDetailCopyWithImpl;
@useResult
$Res call({
 int sourceId, ModType type, String title, ModMedia? media, ModDownload? download, ModRef? manufacturer, ModRef? category, ModRef? country, ModStats? stats, List<ModSpec> specs, String? contentHtml
});


$ModMediaCopyWith<$Res>? get media;$ModDownloadCopyWith<$Res>? get download;$ModRefCopyWith<$Res>? get manufacturer;$ModRefCopyWith<$Res>? get category;$ModRefCopyWith<$Res>? get country;$ModStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class _$ModDetailCopyWithImpl<$Res>
    implements $ModDetailCopyWith<$Res> {
  _$ModDetailCopyWithImpl(this._self, this._then);

  final ModDetail _self;
  final $Res Function(ModDetail) _then;

/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? type = null,Object? title = null,Object? media = freezed,Object? download = freezed,Object? manufacturer = freezed,Object? category = freezed,Object? country = freezed,Object? stats = freezed,Object? specs = null,Object? contentHtml = freezed,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ModMedia?,download: freezed == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as ModDownload?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as ModRef?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ModRef?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as ModRef?,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ModStats?,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as List<ModSpec>,contentHtml: freezed == contentHtml ? _self.contentHtml : contentHtml // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModMediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $ModMediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDownloadCopyWith<$Res>? get download {
    if (_self.download == null) {
    return null;
  }

  return $ModDownloadCopyWith<$Res>(_self.download!, (value) {
    return _then(_self.copyWith(download: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get manufacturer {
    if (_self.manufacturer == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.manufacturer!, (value) {
    return _then(_self.copyWith(manufacturer: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get country {
    if (_self.country == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.country!, (value) {
    return _then(_self.copyWith(country: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModStatsCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $ModStatsCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModDetail].
extension ModDetailPatterns on ModDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModDetail value)  $default,){
final _that = this;
switch (_that) {
case _ModDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ModDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats,  List<ModSpec> specs,  String? contentHtml)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModDetail() when $default != null:
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats,_that.specs,_that.contentHtml);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats,  List<ModSpec> specs,  String? contentHtml)  $default,) {final _that = this;
switch (_that) {
case _ModDetail():
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats,_that.specs,_that.contentHtml);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats,  List<ModSpec> specs,  String? contentHtml)?  $default,) {final _that = this;
switch (_that) {
case _ModDetail() when $default != null:
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats,_that.specs,_that.contentHtml);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModDetail implements ModDetail {
  const _ModDetail({required this.sourceId, required this.type, required this.title, this.media, this.download, this.manufacturer, this.category, this.country, this.stats, final  List<ModSpec> specs = const <ModSpec>[], this.contentHtml}): _specs = specs;
  factory _ModDetail.fromJson(Map<String, dynamic> json) => _$ModDetailFromJson(json);

@override final  int sourceId;
@override final  ModType type;
@override final  String title;
@override final  ModMedia? media;
@override final  ModDownload? download;
@override final  ModRef? manufacturer;
@override final  ModRef? category;
@override final  ModRef? country;
@override final  ModStats? stats;
 final  List<ModSpec> _specs;
@override@JsonKey() List<ModSpec> get specs {
  if (_specs is EqualUnmodifiableListView) return _specs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specs);
}

@override final  String? contentHtml;

/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModDetailCopyWith<_ModDetail> get copyWith => __$ModDetailCopyWithImpl<_ModDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModDetail&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.download, download) || other.download == download)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._specs, _specs)&&(identical(other.contentHtml, contentHtml) || other.contentHtml == contentHtml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,type,title,media,download,manufacturer,category,country,stats,const DeepCollectionEquality().hash(_specs),contentHtml);

@override
String toString() {
  return 'ModDetail(sourceId: $sourceId, type: $type, title: $title, media: $media, download: $download, manufacturer: $manufacturer, category: $category, country: $country, stats: $stats, specs: $specs, contentHtml: $contentHtml)';
}


}

/// @nodoc
abstract mixin class _$ModDetailCopyWith<$Res> implements $ModDetailCopyWith<$Res> {
  factory _$ModDetailCopyWith(_ModDetail value, $Res Function(_ModDetail) _then) = __$ModDetailCopyWithImpl;
@override @useResult
$Res call({
 int sourceId, ModType type, String title, ModMedia? media, ModDownload? download, ModRef? manufacturer, ModRef? category, ModRef? country, ModStats? stats, List<ModSpec> specs, String? contentHtml
});


@override $ModMediaCopyWith<$Res>? get media;@override $ModDownloadCopyWith<$Res>? get download;@override $ModRefCopyWith<$Res>? get manufacturer;@override $ModRefCopyWith<$Res>? get category;@override $ModRefCopyWith<$Res>? get country;@override $ModStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class __$ModDetailCopyWithImpl<$Res>
    implements _$ModDetailCopyWith<$Res> {
  __$ModDetailCopyWithImpl(this._self, this._then);

  final _ModDetail _self;
  final $Res Function(_ModDetail) _then;

/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? type = null,Object? title = null,Object? media = freezed,Object? download = freezed,Object? manufacturer = freezed,Object? category = freezed,Object? country = freezed,Object? stats = freezed,Object? specs = null,Object? contentHtml = freezed,}) {
  return _then(_ModDetail(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ModMedia?,download: freezed == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as ModDownload?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as ModRef?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ModRef?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as ModRef?,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ModStats?,specs: null == specs ? _self._specs : specs // ignore: cast_nullable_to_non_nullable
as List<ModSpec>,contentHtml: freezed == contentHtml ? _self.contentHtml : contentHtml // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModMediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $ModMediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModDownloadCopyWith<$Res>? get download {
    if (_self.download == null) {
    return null;
  }

  return $ModDownloadCopyWith<$Res>(_self.download!, (value) {
    return _then(_self.copyWith(download: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get manufacturer {
    if (_self.manufacturer == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.manufacturer!, (value) {
    return _then(_self.copyWith(manufacturer: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModRefCopyWith<$Res>? get country {
    if (_self.country == null) {
    return null;
  }

  return $ModRefCopyWith<$Res>(_self.country!, (value) {
    return _then(_self.copyWith(country: value));
  });
}/// Create a copy of ModDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModStatsCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $ModStatsCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$ModSpec {

 String get group; String get label; String get value;
/// Create a copy of ModSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModSpecCopyWith<ModSpec> get copyWith => _$ModSpecCopyWithImpl<ModSpec>(this as ModSpec, _$identity);

  /// Serializes this ModSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModSpec&&(identical(other.group, group) || other.group == group)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,label,value);

@override
String toString() {
  return 'ModSpec(group: $group, label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class $ModSpecCopyWith<$Res>  {
  factory $ModSpecCopyWith(ModSpec value, $Res Function(ModSpec) _then) = _$ModSpecCopyWithImpl;
@useResult
$Res call({
 String group, String label, String value
});




}
/// @nodoc
class _$ModSpecCopyWithImpl<$Res>
    implements $ModSpecCopyWith<$Res> {
  _$ModSpecCopyWithImpl(this._self, this._then);

  final ModSpec _self;
  final $Res Function(ModSpec) _then;

/// Create a copy of ModSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = null,Object? label = null,Object? value = null,}) {
  return _then(_self.copyWith(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ModSpec].
extension ModSpecPatterns on ModSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModSpec value)  $default,){
final _that = this;
switch (_that) {
case _ModSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModSpec value)?  $default,){
final _that = this;
switch (_that) {
case _ModSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String group,  String label,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModSpec() when $default != null:
return $default(_that.group,_that.label,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String group,  String label,  String value)  $default,) {final _that = this;
switch (_that) {
case _ModSpec():
return $default(_that.group,_that.label,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String group,  String label,  String value)?  $default,) {final _that = this;
switch (_that) {
case _ModSpec() when $default != null:
return $default(_that.group,_that.label,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModSpec implements ModSpec {
  const _ModSpec({required this.group, required this.label, required this.value});
  factory _ModSpec.fromJson(Map<String, dynamic> json) => _$ModSpecFromJson(json);

@override final  String group;
@override final  String label;
@override final  String value;

/// Create a copy of ModSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModSpecCopyWith<_ModSpec> get copyWith => __$ModSpecCopyWithImpl<_ModSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModSpec&&(identical(other.group, group) || other.group == group)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,label,value);

@override
String toString() {
  return 'ModSpec(group: $group, label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ModSpecCopyWith<$Res> implements $ModSpecCopyWith<$Res> {
  factory _$ModSpecCopyWith(_ModSpec value, $Res Function(_ModSpec) _then) = __$ModSpecCopyWithImpl;
@override @useResult
$Res call({
 String group, String label, String value
});




}
/// @nodoc
class __$ModSpecCopyWithImpl<$Res>
    implements _$ModSpecCopyWith<$Res> {
  __$ModSpecCopyWithImpl(this._self, this._then);

  final _ModSpec _self;
  final $Res Function(_ModSpec) _then;

/// Create a copy of ModSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = null,Object? label = null,Object? value = null,}) {
  return _then(_ModSpec(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
