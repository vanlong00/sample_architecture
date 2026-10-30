// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_purchase_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionPurchaseResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionPurchaseResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult()';
}


}

/// @nodoc
class $SubscriptionPurchaseResultCopyWith<$Res>  {
$SubscriptionPurchaseResultCopyWith(SubscriptionPurchaseResult _, $Res Function(SubscriptionPurchaseResult) __);
}


/// Adds pattern-matching-related methods to [SubscriptionPurchaseResult].
extension SubscriptionPurchaseResultPatterns on SubscriptionPurchaseResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PurchaseSucceeded value)?  purchased,TResult Function( PurchaseRestored value)?  restored,TResult Function( PurchasePending value)?  pending,TResult Function( PurchaseCanceled value)?  canceled,TResult Function( PurchaseFailed value)?  error,TResult Function( NothingToRestore value)?  nothingToRestore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PurchaseSucceeded() when purchased != null:
return purchased(_that);case PurchaseRestored() when restored != null:
return restored(_that);case PurchasePending() when pending != null:
return pending(_that);case PurchaseCanceled() when canceled != null:
return canceled(_that);case PurchaseFailed() when error != null:
return error(_that);case NothingToRestore() when nothingToRestore != null:
return nothingToRestore(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PurchaseSucceeded value)  purchased,required TResult Function( PurchaseRestored value)  restored,required TResult Function( PurchasePending value)  pending,required TResult Function( PurchaseCanceled value)  canceled,required TResult Function( PurchaseFailed value)  error,required TResult Function( NothingToRestore value)  nothingToRestore,}){
final _that = this;
switch (_that) {
case PurchaseSucceeded():
return purchased(_that);case PurchaseRestored():
return restored(_that);case PurchasePending():
return pending(_that);case PurchaseCanceled():
return canceled(_that);case PurchaseFailed():
return error(_that);case NothingToRestore():
return nothingToRestore(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PurchaseSucceeded value)?  purchased,TResult? Function( PurchaseRestored value)?  restored,TResult? Function( PurchasePending value)?  pending,TResult? Function( PurchaseCanceled value)?  canceled,TResult? Function( PurchaseFailed value)?  error,TResult? Function( NothingToRestore value)?  nothingToRestore,}){
final _that = this;
switch (_that) {
case PurchaseSucceeded() when purchased != null:
return purchased(_that);case PurchaseRestored() when restored != null:
return restored(_that);case PurchasePending() when pending != null:
return pending(_that);case PurchaseCanceled() when canceled != null:
return canceled(_that);case PurchaseFailed() when error != null:
return error(_that);case NothingToRestore() when nothingToRestore != null:
return nothingToRestore(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  purchased,TResult Function()?  restored,TResult Function()?  pending,TResult Function()?  canceled,TResult Function( String message)?  error,TResult Function()?  nothingToRestore,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PurchaseSucceeded() when purchased != null:
return purchased();case PurchaseRestored() when restored != null:
return restored();case PurchasePending() when pending != null:
return pending();case PurchaseCanceled() when canceled != null:
return canceled();case PurchaseFailed() when error != null:
return error(_that.message);case NothingToRestore() when nothingToRestore != null:
return nothingToRestore();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  purchased,required TResult Function()  restored,required TResult Function()  pending,required TResult Function()  canceled,required TResult Function( String message)  error,required TResult Function()  nothingToRestore,}) {final _that = this;
switch (_that) {
case PurchaseSucceeded():
return purchased();case PurchaseRestored():
return restored();case PurchasePending():
return pending();case PurchaseCanceled():
return canceled();case PurchaseFailed():
return error(_that.message);case NothingToRestore():
return nothingToRestore();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  purchased,TResult? Function()?  restored,TResult? Function()?  pending,TResult? Function()?  canceled,TResult? Function( String message)?  error,TResult? Function()?  nothingToRestore,}) {final _that = this;
switch (_that) {
case PurchaseSucceeded() when purchased != null:
return purchased();case PurchaseRestored() when restored != null:
return restored();case PurchasePending() when pending != null:
return pending();case PurchaseCanceled() when canceled != null:
return canceled();case PurchaseFailed() when error != null:
return error(_that.message);case NothingToRestore() when nothingToRestore != null:
return nothingToRestore();case _:
  return null;

}
}

}

/// @nodoc


class PurchaseSucceeded implements SubscriptionPurchaseResult {
  const PurchaseSucceeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseSucceeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult.purchased()';
}


}




/// @nodoc


class PurchaseRestored implements SubscriptionPurchaseResult {
  const PurchaseRestored();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRestored);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult.restored()';
}


}




/// @nodoc


class PurchasePending implements SubscriptionPurchaseResult {
  const PurchasePending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchasePending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult.pending()';
}


}




/// @nodoc


class PurchaseCanceled implements SubscriptionPurchaseResult {
  const PurchaseCanceled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseCanceled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult.canceled()';
}


}




/// @nodoc


class PurchaseFailed implements SubscriptionPurchaseResult {
  const PurchaseFailed(this.message);
  

 final  String message;

/// Create a copy of SubscriptionPurchaseResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseFailedCopyWith<PurchaseFailed> get copyWith => _$PurchaseFailedCopyWithImpl<PurchaseFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SubscriptionPurchaseResult.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PurchaseFailedCopyWith<$Res> implements $SubscriptionPurchaseResultCopyWith<$Res> {
  factory $PurchaseFailedCopyWith(PurchaseFailed value, $Res Function(PurchaseFailed) _then) = _$PurchaseFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PurchaseFailedCopyWithImpl<$Res>
    implements $PurchaseFailedCopyWith<$Res> {
  _$PurchaseFailedCopyWithImpl(this._self, this._then);

  final PurchaseFailed _self;
  final $Res Function(PurchaseFailed) _then;

/// Create a copy of SubscriptionPurchaseResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PurchaseFailed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NothingToRestore implements SubscriptionPurchaseResult {
  const NothingToRestore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NothingToRestore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionPurchaseResult.nothingToRestore()';
}


}




// dart format on
