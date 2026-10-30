// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModCard {

 int get sourceId; ModType get type; String get title; ModMedia? get media; ModDownload? get download; ModRef? get manufacturer; ModRef? get category; ModRef? get country; ModStats? get stats;
/// Create a copy of ModCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModCardCopyWith<ModCard> get copyWith => _$ModCardCopyWithImpl<ModCard>(this as ModCard, _$identity);

  /// Serializes this ModCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModCard&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.download, download) || other.download == download)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,type,title,media,download,manufacturer,category,country,stats);

@override
String toString() {
  return 'ModCard(sourceId: $sourceId, type: $type, title: $title, media: $media, download: $download, manufacturer: $manufacturer, category: $category, country: $country, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $ModCardCopyWith<$Res>  {
  factory $ModCardCopyWith(ModCard value, $Res Function(ModCard) _then) = _$ModCardCopyWithImpl;
@useResult
$Res call({
 int sourceId, ModType type, String title, ModMedia? media, ModDownload? download, ModRef? manufacturer, ModRef? category, ModRef? country, ModStats? stats
});


$ModMediaCopyWith<$Res>? get media;$ModDownloadCopyWith<$Res>? get download;$ModRefCopyWith<$Res>? get manufacturer;$ModRefCopyWith<$Res>? get category;$ModRefCopyWith<$Res>? get country;$ModStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class _$ModCardCopyWithImpl<$Res>
    implements $ModCardCopyWith<$Res> {
  _$ModCardCopyWithImpl(this._self, this._then);

  final ModCard _self;
  final $Res Function(ModCard) _then;

/// Create a copy of ModCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? type = null,Object? title = null,Object? media = freezed,Object? download = freezed,Object? manufacturer = freezed,Object? category = freezed,Object? country = freezed,Object? stats = freezed,}) {
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
as ModStats?,
  ));
}
/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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


/// Adds pattern-matching-related methods to [ModCard].
extension ModCardPatterns on ModCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModCard value)  $default,){
final _that = this;
switch (_that) {
case _ModCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModCard value)?  $default,){
final _that = this;
switch (_that) {
case _ModCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModCard() when $default != null:
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats)  $default,) {final _that = this;
switch (_that) {
case _ModCard():
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sourceId,  ModType type,  String title,  ModMedia? media,  ModDownload? download,  ModRef? manufacturer,  ModRef? category,  ModRef? country,  ModStats? stats)?  $default,) {final _that = this;
switch (_that) {
case _ModCard() when $default != null:
return $default(_that.sourceId,_that.type,_that.title,_that.media,_that.download,_that.manufacturer,_that.category,_that.country,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModCard implements ModCard {
  const _ModCard({required this.sourceId, required this.type, required this.title, this.media, this.download, this.manufacturer, this.category, this.country, this.stats});
  factory _ModCard.fromJson(Map<String, dynamic> json) => _$ModCardFromJson(json);

@override final  int sourceId;
@override final  ModType type;
@override final  String title;
@override final  ModMedia? media;
@override final  ModDownload? download;
@override final  ModRef? manufacturer;
@override final  ModRef? category;
@override final  ModRef? country;
@override final  ModStats? stats;

/// Create a copy of ModCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModCardCopyWith<_ModCard> get copyWith => __$ModCardCopyWithImpl<_ModCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModCard&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.download, download) || other.download == download)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,type,title,media,download,manufacturer,category,country,stats);

@override
String toString() {
  return 'ModCard(sourceId: $sourceId, type: $type, title: $title, media: $media, download: $download, manufacturer: $manufacturer, category: $category, country: $country, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$ModCardCopyWith<$Res> implements $ModCardCopyWith<$Res> {
  factory _$ModCardCopyWith(_ModCard value, $Res Function(_ModCard) _then) = __$ModCardCopyWithImpl;
@override @useResult
$Res call({
 int sourceId, ModType type, String title, ModMedia? media, ModDownload? download, ModRef? manufacturer, ModRef? category, ModRef? country, ModStats? stats
});


@override $ModMediaCopyWith<$Res>? get media;@override $ModDownloadCopyWith<$Res>? get download;@override $ModRefCopyWith<$Res>? get manufacturer;@override $ModRefCopyWith<$Res>? get category;@override $ModRefCopyWith<$Res>? get country;@override $ModStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class __$ModCardCopyWithImpl<$Res>
    implements _$ModCardCopyWith<$Res> {
  __$ModCardCopyWithImpl(this._self, this._then);

  final _ModCard _self;
  final $Res Function(_ModCard) _then;

/// Create a copy of ModCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? type = null,Object? title = null,Object? media = freezed,Object? download = freezed,Object? manufacturer = freezed,Object? category = freezed,Object? country = freezed,Object? stats = freezed,}) {
  return _then(_ModCard(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ModMedia?,download: freezed == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as ModDownload?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as ModRef?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ModRef?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as ModRef?,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ModStats?,
  ));
}

/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
}/// Create a copy of ModCard
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
mixin _$ModMedia {

 String? get thumbnail; List<String> get images;
/// Create a copy of ModMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModMediaCopyWith<ModMedia> get copyWith => _$ModMediaCopyWithImpl<ModMedia>(this as ModMedia, _$identity);

  /// Serializes this ModMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModMedia&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,thumbnail,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'ModMedia(thumbnail: $thumbnail, images: $images)';
}


}

/// @nodoc
abstract mixin class $ModMediaCopyWith<$Res>  {
  factory $ModMediaCopyWith(ModMedia value, $Res Function(ModMedia) _then) = _$ModMediaCopyWithImpl;
@useResult
$Res call({
 String? thumbnail, List<String> images
});




}
/// @nodoc
class _$ModMediaCopyWithImpl<$Res>
    implements $ModMediaCopyWith<$Res> {
  _$ModMediaCopyWithImpl(this._self, this._then);

  final ModMedia _self;
  final $Res Function(ModMedia) _then;

/// Create a copy of ModMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? thumbnail = freezed,Object? images = null,}) {
  return _then(_self.copyWith(
thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModMedia].
extension ModMediaPatterns on ModMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModMedia value)  $default,){
final _that = this;
switch (_that) {
case _ModMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModMedia value)?  $default,){
final _that = this;
switch (_that) {
case _ModMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? thumbnail,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModMedia() when $default != null:
return $default(_that.thumbnail,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? thumbnail,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _ModMedia():
return $default(_that.thumbnail,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? thumbnail,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _ModMedia() when $default != null:
return $default(_that.thumbnail,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModMedia implements ModMedia {
  const _ModMedia({this.thumbnail, final  List<String> images = const <String>[]}): _images = images;
  factory _ModMedia.fromJson(Map<String, dynamic> json) => _$ModMediaFromJson(json);

@override final  String? thumbnail;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of ModMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModMediaCopyWith<_ModMedia> get copyWith => __$ModMediaCopyWithImpl<_ModMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModMedia&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,thumbnail,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'ModMedia(thumbnail: $thumbnail, images: $images)';
}


}

/// @nodoc
abstract mixin class _$ModMediaCopyWith<$Res> implements $ModMediaCopyWith<$Res> {
  factory _$ModMediaCopyWith(_ModMedia value, $Res Function(_ModMedia) _then) = __$ModMediaCopyWithImpl;
@override @useResult
$Res call({
 String? thumbnail, List<String> images
});




}
/// @nodoc
class __$ModMediaCopyWithImpl<$Res>
    implements _$ModMediaCopyWith<$Res> {
  __$ModMediaCopyWithImpl(this._self, this._then);

  final _ModMedia _self;
  final $Res Function(_ModMedia) _then;

/// Create a copy of ModMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? thumbnail = freezed,Object? images = null,}) {
  return _then(_ModMedia(
thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ModStats {

 int? get downloads;
/// Create a copy of ModStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModStatsCopyWith<ModStats> get copyWith => _$ModStatsCopyWithImpl<ModStats>(this as ModStats, _$identity);

  /// Serializes this ModStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModStats&&(identical(other.downloads, downloads) || other.downloads == downloads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloads);

@override
String toString() {
  return 'ModStats(downloads: $downloads)';
}


}

/// @nodoc
abstract mixin class $ModStatsCopyWith<$Res>  {
  factory $ModStatsCopyWith(ModStats value, $Res Function(ModStats) _then) = _$ModStatsCopyWithImpl;
@useResult
$Res call({
 int? downloads
});




}
/// @nodoc
class _$ModStatsCopyWithImpl<$Res>
    implements $ModStatsCopyWith<$Res> {
  _$ModStatsCopyWithImpl(this._self, this._then);

  final ModStats _self;
  final $Res Function(ModStats) _then;

/// Create a copy of ModStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloads = freezed,}) {
  return _then(_self.copyWith(
downloads: freezed == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModStats].
extension ModStatsPatterns on ModStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModStats value)  $default,){
final _that = this;
switch (_that) {
case _ModStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModStats value)?  $default,){
final _that = this;
switch (_that) {
case _ModStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? downloads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModStats() when $default != null:
return $default(_that.downloads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? downloads)  $default,) {final _that = this;
switch (_that) {
case _ModStats():
return $default(_that.downloads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? downloads)?  $default,) {final _that = this;
switch (_that) {
case _ModStats() when $default != null:
return $default(_that.downloads);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModStats implements ModStats {
  const _ModStats({this.downloads});
  factory _ModStats.fromJson(Map<String, dynamic> json) => _$ModStatsFromJson(json);

@override final  int? downloads;

/// Create a copy of ModStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModStatsCopyWith<_ModStats> get copyWith => __$ModStatsCopyWithImpl<_ModStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModStats&&(identical(other.downloads, downloads) || other.downloads == downloads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloads);

@override
String toString() {
  return 'ModStats(downloads: $downloads)';
}


}

/// @nodoc
abstract mixin class _$ModStatsCopyWith<$Res> implements $ModStatsCopyWith<$Res> {
  factory _$ModStatsCopyWith(_ModStats value, $Res Function(_ModStats) _then) = __$ModStatsCopyWithImpl;
@override @useResult
$Res call({
 int? downloads
});




}
/// @nodoc
class __$ModStatsCopyWithImpl<$Res>
    implements _$ModStatsCopyWith<$Res> {
  __$ModStatsCopyWithImpl(this._self, this._then);

  final _ModStats _self;
  final $Res Function(_ModStats) _then;

/// Create a copy of ModStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloads = freezed,}) {
  return _then(_ModStats(
downloads: freezed == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ModRef {

@JsonKey(name: '_id') String get id; String? get name;
/// Create a copy of ModRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModRefCopyWith<ModRef> get copyWith => _$ModRefCopyWithImpl<ModRef>(this as ModRef, _$identity);

  /// Serializes this ModRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ModRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ModRefCopyWith<$Res>  {
  factory $ModRefCopyWith(ModRef value, $Res Function(ModRef) _then) = _$ModRefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String? name
});




}
/// @nodoc
class _$ModRefCopyWithImpl<$Res>
    implements $ModRefCopyWith<$Res> {
  _$ModRefCopyWithImpl(this._self, this._then);

  final ModRef _self;
  final $Res Function(ModRef) _then;

/// Create a copy of ModRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModRef].
extension ModRefPatterns on ModRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModRef value)  $default,){
final _that = this;
switch (_that) {
case _ModRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModRef value)?  $default,){
final _that = this;
switch (_that) {
case _ModRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModRef() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? name)  $default,) {final _that = this;
switch (_that) {
case _ModRef():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _ModRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModRef implements ModRef {
  const _ModRef({@JsonKey(name: '_id') required this.id, this.name});
  factory _ModRef.fromJson(Map<String, dynamic> json) => _$ModRefFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String? name;

/// Create a copy of ModRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModRefCopyWith<_ModRef> get copyWith => __$ModRefCopyWithImpl<_ModRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ModRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ModRefCopyWith<$Res> implements $ModRefCopyWith<$Res> {
  factory _$ModRefCopyWith(_ModRef value, $Res Function(_ModRef) _then) = __$ModRefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String? name
});




}
/// @nodoc
class __$ModRefCopyWithImpl<$Res>
    implements _$ModRefCopyWith<$Res> {
  __$ModRefCopyWithImpl(this._self, this._then);

  final _ModRef _self;
  final $Res Function(_ModRef) _then;

/// Create a copy of ModRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(_ModRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ModDownload {

 String? get storageUrl; int? get sizeBytes; String? get fileFormat;
/// Create a copy of ModDownload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModDownloadCopyWith<ModDownload> get copyWith => _$ModDownloadCopyWithImpl<ModDownload>(this as ModDownload, _$identity);

  /// Serializes this ModDownload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModDownload&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.fileFormat, fileFormat) || other.fileFormat == fileFormat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageUrl,sizeBytes,fileFormat);

@override
String toString() {
  return 'ModDownload(storageUrl: $storageUrl, sizeBytes: $sizeBytes, fileFormat: $fileFormat)';
}


}

/// @nodoc
abstract mixin class $ModDownloadCopyWith<$Res>  {
  factory $ModDownloadCopyWith(ModDownload value, $Res Function(ModDownload) _then) = _$ModDownloadCopyWithImpl;
@useResult
$Res call({
 String? storageUrl, int? sizeBytes, String? fileFormat
});




}
/// @nodoc
class _$ModDownloadCopyWithImpl<$Res>
    implements $ModDownloadCopyWith<$Res> {
  _$ModDownloadCopyWithImpl(this._self, this._then);

  final ModDownload _self;
  final $Res Function(ModDownload) _then;

/// Create a copy of ModDownload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageUrl = freezed,Object? sizeBytes = freezed,Object? fileFormat = freezed,}) {
  return _then(_self.copyWith(
storageUrl: freezed == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,fileFormat: freezed == fileFormat ? _self.fileFormat : fileFormat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModDownload].
extension ModDownloadPatterns on ModDownload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModDownload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModDownload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModDownload value)  $default,){
final _that = this;
switch (_that) {
case _ModDownload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModDownload value)?  $default,){
final _that = this;
switch (_that) {
case _ModDownload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? storageUrl,  int? sizeBytes,  String? fileFormat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModDownload() when $default != null:
return $default(_that.storageUrl,_that.sizeBytes,_that.fileFormat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? storageUrl,  int? sizeBytes,  String? fileFormat)  $default,) {final _that = this;
switch (_that) {
case _ModDownload():
return $default(_that.storageUrl,_that.sizeBytes,_that.fileFormat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? storageUrl,  int? sizeBytes,  String? fileFormat)?  $default,) {final _that = this;
switch (_that) {
case _ModDownload() when $default != null:
return $default(_that.storageUrl,_that.sizeBytes,_that.fileFormat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModDownload implements ModDownload {
  const _ModDownload({this.storageUrl, this.sizeBytes, this.fileFormat});
  factory _ModDownload.fromJson(Map<String, dynamic> json) => _$ModDownloadFromJson(json);

@override final  String? storageUrl;
@override final  int? sizeBytes;
@override final  String? fileFormat;

/// Create a copy of ModDownload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModDownloadCopyWith<_ModDownload> get copyWith => __$ModDownloadCopyWithImpl<_ModDownload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModDownloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModDownload&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.fileFormat, fileFormat) || other.fileFormat == fileFormat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageUrl,sizeBytes,fileFormat);

@override
String toString() {
  return 'ModDownload(storageUrl: $storageUrl, sizeBytes: $sizeBytes, fileFormat: $fileFormat)';
}


}

/// @nodoc
abstract mixin class _$ModDownloadCopyWith<$Res> implements $ModDownloadCopyWith<$Res> {
  factory _$ModDownloadCopyWith(_ModDownload value, $Res Function(_ModDownload) _then) = __$ModDownloadCopyWithImpl;
@override @useResult
$Res call({
 String? storageUrl, int? sizeBytes, String? fileFormat
});




}
/// @nodoc
class __$ModDownloadCopyWithImpl<$Res>
    implements _$ModDownloadCopyWith<$Res> {
  __$ModDownloadCopyWithImpl(this._self, this._then);

  final _ModDownload _self;
  final $Res Function(_ModDownload) _then;

/// Create a copy of ModDownload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageUrl = freezed,Object? sizeBytes = freezed,Object? fileFormat = freezed,}) {
  return _then(_ModDownload(
storageUrl: freezed == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,fileFormat: freezed == fileFormat ? _self.fileFormat : fileFormat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
