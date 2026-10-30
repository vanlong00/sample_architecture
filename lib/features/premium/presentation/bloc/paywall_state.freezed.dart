// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paywall_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaywallState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState()';
}


}

/// @nodoc
class $PaywallStateCopyWith<$Res>  {
$PaywallStateCopyWith(PaywallState _, $Res Function(PaywallState) __);
}


/// Adds pattern-matching-related methods to [PaywallState].
extension PaywallStatePatterns on PaywallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaywallIdle value)?  idle,TResult Function( PaywallPurchasing value)?  purchasing,TResult Function( PaywallRestoring value)?  restoring,TResult Function( PaywallPending value)?  pending,TResult Function( PaywallPurchased value)?  purchased,TResult Function( PaywallRestored value)?  restored,TResult Function( PaywallError value)?  error,TResult Function( PaywallInfo value)?  info,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaywallIdle() when idle != null:
return idle(_that);case PaywallPurchasing() when purchasing != null:
return purchasing(_that);case PaywallRestoring() when restoring != null:
return restoring(_that);case PaywallPending() when pending != null:
return pending(_that);case PaywallPurchased() when purchased != null:
return purchased(_that);case PaywallRestored() when restored != null:
return restored(_that);case PaywallError() when error != null:
return error(_that);case PaywallInfo() when info != null:
return info(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaywallIdle value)  idle,required TResult Function( PaywallPurchasing value)  purchasing,required TResult Function( PaywallRestoring value)  restoring,required TResult Function( PaywallPending value)  pending,required TResult Function( PaywallPurchased value)  purchased,required TResult Function( PaywallRestored value)  restored,required TResult Function( PaywallError value)  error,required TResult Function( PaywallInfo value)  info,}){
final _that = this;
switch (_that) {
case PaywallIdle():
return idle(_that);case PaywallPurchasing():
return purchasing(_that);case PaywallRestoring():
return restoring(_that);case PaywallPending():
return pending(_that);case PaywallPurchased():
return purchased(_that);case PaywallRestored():
return restored(_that);case PaywallError():
return error(_that);case PaywallInfo():
return info(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaywallIdle value)?  idle,TResult? Function( PaywallPurchasing value)?  purchasing,TResult? Function( PaywallRestoring value)?  restoring,TResult? Function( PaywallPending value)?  pending,TResult? Function( PaywallPurchased value)?  purchased,TResult? Function( PaywallRestored value)?  restored,TResult? Function( PaywallError value)?  error,TResult? Function( PaywallInfo value)?  info,}){
final _that = this;
switch (_that) {
case PaywallIdle() when idle != null:
return idle(_that);case PaywallPurchasing() when purchasing != null:
return purchasing(_that);case PaywallRestoring() when restoring != null:
return restoring(_that);case PaywallPending() when pending != null:
return pending(_that);case PaywallPurchased() when purchased != null:
return purchased(_that);case PaywallRestored() when restored != null:
return restored(_that);case PaywallError() when error != null:
return error(_that);case PaywallInfo() when info != null:
return info(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  purchasing,TResult Function()?  restoring,TResult Function()?  pending,TResult Function()?  purchased,TResult Function()?  restored,TResult Function( String message,  bool fromRestore)?  error,TResult Function( String message)?  info,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaywallIdle() when idle != null:
return idle();case PaywallPurchasing() when purchasing != null:
return purchasing();case PaywallRestoring() when restoring != null:
return restoring();case PaywallPending() when pending != null:
return pending();case PaywallPurchased() when purchased != null:
return purchased();case PaywallRestored() when restored != null:
return restored();case PaywallError() when error != null:
return error(_that.message,_that.fromRestore);case PaywallInfo() when info != null:
return info(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  purchasing,required TResult Function()  restoring,required TResult Function()  pending,required TResult Function()  purchased,required TResult Function()  restored,required TResult Function( String message,  bool fromRestore)  error,required TResult Function( String message)  info,}) {final _that = this;
switch (_that) {
case PaywallIdle():
return idle();case PaywallPurchasing():
return purchasing();case PaywallRestoring():
return restoring();case PaywallPending():
return pending();case PaywallPurchased():
return purchased();case PaywallRestored():
return restored();case PaywallError():
return error(_that.message,_that.fromRestore);case PaywallInfo():
return info(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  purchasing,TResult? Function()?  restoring,TResult? Function()?  pending,TResult? Function()?  purchased,TResult? Function()?  restored,TResult? Function( String message,  bool fromRestore)?  error,TResult? Function( String message)?  info,}) {final _that = this;
switch (_that) {
case PaywallIdle() when idle != null:
return idle();case PaywallPurchasing() when purchasing != null:
return purchasing();case PaywallRestoring() when restoring != null:
return restoring();case PaywallPending() when pending != null:
return pending();case PaywallPurchased() when purchased != null:
return purchased();case PaywallRestored() when restored != null:
return restored();case PaywallError() when error != null:
return error(_that.message,_that.fromRestore);case PaywallInfo() when info != null:
return info(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PaywallIdle implements PaywallState {
  const PaywallIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.idle()';
}


}




/// @nodoc


class PaywallPurchasing implements PaywallState {
  const PaywallPurchasing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPurchasing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.purchasing()';
}


}




/// @nodoc


class PaywallRestoring implements PaywallState {
  const PaywallRestoring();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallRestoring);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.restoring()';
}


}




/// @nodoc


class PaywallPending implements PaywallState {
  const PaywallPending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.pending()';
}


}




/// @nodoc


class PaywallPurchased implements PaywallState {
  const PaywallPurchased();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPurchased);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.purchased()';
}


}




/// @nodoc


class PaywallRestored implements PaywallState {
  const PaywallRestored();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallRestored);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaywallState.restored()';
}


}




/// @nodoc


class PaywallError implements PaywallState {
  const PaywallError(this.message, {this.fromRestore = false});
  

 final  String message;
// True when a restore (not a purchase) failed, for the right UI message.
@JsonKey() final  bool fromRestore;

/// Create a copy of PaywallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallErrorCopyWith<PaywallError> get copyWith => _$PaywallErrorCopyWithImpl<PaywallError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallError&&(identical(other.message, message) || other.message == message)&&(identical(other.fromRestore, fromRestore) || other.fromRestore == fromRestore));
}


@override
int get hashCode => Object.hash(runtimeType,message,fromRestore);

@override
String toString() {
  return 'PaywallState.error(message: $message, fromRestore: $fromRestore)';
}


}

/// @nodoc
abstract mixin class $PaywallErrorCopyWith<$Res> implements $PaywallStateCopyWith<$Res> {
  factory $PaywallErrorCopyWith(PaywallError value, $Res Function(PaywallError) _then) = _$PaywallErrorCopyWithImpl;
@useResult
$Res call({
 String message, bool fromRestore
});




}
/// @nodoc
class _$PaywallErrorCopyWithImpl<$Res>
    implements $PaywallErrorCopyWith<$Res> {
  _$PaywallErrorCopyWithImpl(this._self, this._then);

  final PaywallError _self;
  final $Res Function(PaywallError) _then;

/// Create a copy of PaywallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? fromRestore = null,}) {
  return _then(PaywallError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fromRestore: null == fromRestore ? _self.fromRestore : fromRestore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaywallInfo implements PaywallState {
  const PaywallInfo(this.message);
  

 final  String message;

/// Create a copy of PaywallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallInfoCopyWith<PaywallInfo> get copyWith => _$PaywallInfoCopyWithImpl<PaywallInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallInfo&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PaywallState.info(message: $message)';
}


}

/// @nodoc
abstract mixin class $PaywallInfoCopyWith<$Res> implements $PaywallStateCopyWith<$Res> {
  factory $PaywallInfoCopyWith(PaywallInfo value, $Res Function(PaywallInfo) _then) = _$PaywallInfoCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PaywallInfoCopyWithImpl<$Res>
    implements $PaywallInfoCopyWith<$Res> {
  _$PaywallInfoCopyWithImpl(this._self, this._then);

  final PaywallInfo _self;
  final $Res Function(PaywallInfo) _then;

/// Create a copy of PaywallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PaywallInfo(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
