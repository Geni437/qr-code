// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductViewCount {

 String get productId; String get productName; int get count;
/// Create a copy of ProductViewCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductViewCountCopyWith<ProductViewCount> get copyWith => _$ProductViewCountCopyWithImpl<ProductViewCount>(this as ProductViewCount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductViewCount&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,count);

@override
String toString() {
  return 'ProductViewCount(productId: $productId, productName: $productName, count: $count)';
}


}

/// @nodoc
abstract mixin class $ProductViewCountCopyWith<$Res>  {
  factory $ProductViewCountCopyWith(ProductViewCount value, $Res Function(ProductViewCount) _then) = _$ProductViewCountCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, int count
});




}
/// @nodoc
class _$ProductViewCountCopyWithImpl<$Res>
    implements $ProductViewCountCopyWith<$Res> {
  _$ProductViewCountCopyWithImpl(this._self, this._then);

  final ProductViewCount _self;
  final $Res Function(ProductViewCount) _then;

/// Create a copy of ProductViewCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? count = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductViewCount].
extension ProductViewCountPatterns on ProductViewCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductViewCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductViewCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductViewCount value)  $default,){
final _that = this;
switch (_that) {
case _ProductViewCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductViewCount value)?  $default,){
final _that = this;
switch (_that) {
case _ProductViewCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductViewCount() when $default != null:
return $default(_that.productId,_that.productName,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  int count)  $default,) {final _that = this;
switch (_that) {
case _ProductViewCount():
return $default(_that.productId,_that.productName,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ProductViewCount() when $default != null:
return $default(_that.productId,_that.productName,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _ProductViewCount implements ProductViewCount {
  const _ProductViewCount({required this.productId, required this.productName, required this.count});
  

@override final  String productId;
@override final  String productName;
@override final  int count;

/// Create a copy of ProductViewCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductViewCountCopyWith<_ProductViewCount> get copyWith => __$ProductViewCountCopyWithImpl<_ProductViewCount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductViewCount&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,count);

@override
String toString() {
  return 'ProductViewCount(productId: $productId, productName: $productName, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ProductViewCountCopyWith<$Res> implements $ProductViewCountCopyWith<$Res> {
  factory _$ProductViewCountCopyWith(_ProductViewCount value, $Res Function(_ProductViewCount) _then) = __$ProductViewCountCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, int count
});




}
/// @nodoc
class __$ProductViewCountCopyWithImpl<$Res>
    implements _$ProductViewCountCopyWith<$Res> {
  __$ProductViewCountCopyWithImpl(this._self, this._then);

  final _ProductViewCount _self;
  final $Res Function(_ProductViewCount) _then;

/// Create a copy of ProductViewCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? count = null,}) {
  return _then(_ProductViewCount(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AnalyticsOverview {

/// Scan counts for the last 30 days, oldest first (index 29 = today).
 List<int> get scansLast30Days; List<ProductViewCount> get mostViewedProducts; Map<String, int> get eventTypeCounts; Map<String, int> get deviceTypeCounts;
/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsOverviewCopyWith<AnalyticsOverview> get copyWith => _$AnalyticsOverviewCopyWithImpl<AnalyticsOverview>(this as AnalyticsOverview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsOverview&&const DeepCollectionEquality().equals(other.scansLast30Days, scansLast30Days)&&const DeepCollectionEquality().equals(other.mostViewedProducts, mostViewedProducts)&&const DeepCollectionEquality().equals(other.eventTypeCounts, eventTypeCounts)&&const DeepCollectionEquality().equals(other.deviceTypeCounts, deviceTypeCounts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(scansLast30Days),const DeepCollectionEquality().hash(mostViewedProducts),const DeepCollectionEquality().hash(eventTypeCounts),const DeepCollectionEquality().hash(deviceTypeCounts));

@override
String toString() {
  return 'AnalyticsOverview(scansLast30Days: $scansLast30Days, mostViewedProducts: $mostViewedProducts, eventTypeCounts: $eventTypeCounts, deviceTypeCounts: $deviceTypeCounts)';
}


}

/// @nodoc
abstract mixin class $AnalyticsOverviewCopyWith<$Res>  {
  factory $AnalyticsOverviewCopyWith(AnalyticsOverview value, $Res Function(AnalyticsOverview) _then) = _$AnalyticsOverviewCopyWithImpl;
@useResult
$Res call({
 List<int> scansLast30Days, List<ProductViewCount> mostViewedProducts, Map<String, int> eventTypeCounts, Map<String, int> deviceTypeCounts
});




}
/// @nodoc
class _$AnalyticsOverviewCopyWithImpl<$Res>
    implements $AnalyticsOverviewCopyWith<$Res> {
  _$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final AnalyticsOverview _self;
  final $Res Function(AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scansLast30Days = null,Object? mostViewedProducts = null,Object? eventTypeCounts = null,Object? deviceTypeCounts = null,}) {
  return _then(_self.copyWith(
scansLast30Days: null == scansLast30Days ? _self.scansLast30Days : scansLast30Days // ignore: cast_nullable_to_non_nullable
as List<int>,mostViewedProducts: null == mostViewedProducts ? _self.mostViewedProducts : mostViewedProducts // ignore: cast_nullable_to_non_nullable
as List<ProductViewCount>,eventTypeCounts: null == eventTypeCounts ? _self.eventTypeCounts : eventTypeCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deviceTypeCounts: null == deviceTypeCounts ? _self.deviceTypeCounts : deviceTypeCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsOverview].
extension AnalyticsOverviewPatterns on AnalyticsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsOverview value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> scansLast30Days,  List<ProductViewCount> mostViewedProducts,  Map<String, int> eventTypeCounts,  Map<String, int> deviceTypeCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.scansLast30Days,_that.mostViewedProducts,_that.eventTypeCounts,_that.deviceTypeCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> scansLast30Days,  List<ProductViewCount> mostViewedProducts,  Map<String, int> eventTypeCounts,  Map<String, int> deviceTypeCounts)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview():
return $default(_that.scansLast30Days,_that.mostViewedProducts,_that.eventTypeCounts,_that.deviceTypeCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> scansLast30Days,  List<ProductViewCount> mostViewedProducts,  Map<String, int> eventTypeCounts,  Map<String, int> deviceTypeCounts)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsOverview() when $default != null:
return $default(_that.scansLast30Days,_that.mostViewedProducts,_that.eventTypeCounts,_that.deviceTypeCounts);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsOverview implements AnalyticsOverview {
  const _AnalyticsOverview({required final  List<int> scansLast30Days, required final  List<ProductViewCount> mostViewedProducts, required final  Map<String, int> eventTypeCounts, required final  Map<String, int> deviceTypeCounts}): _scansLast30Days = scansLast30Days,_mostViewedProducts = mostViewedProducts,_eventTypeCounts = eventTypeCounts,_deviceTypeCounts = deviceTypeCounts;
  

/// Scan counts for the last 30 days, oldest first (index 29 = today).
 final  List<int> _scansLast30Days;
/// Scan counts for the last 30 days, oldest first (index 29 = today).
@override List<int> get scansLast30Days {
  if (_scansLast30Days is EqualUnmodifiableListView) return _scansLast30Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scansLast30Days);
}

 final  List<ProductViewCount> _mostViewedProducts;
@override List<ProductViewCount> get mostViewedProducts {
  if (_mostViewedProducts is EqualUnmodifiableListView) return _mostViewedProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostViewedProducts);
}

 final  Map<String, int> _eventTypeCounts;
@override Map<String, int> get eventTypeCounts {
  if (_eventTypeCounts is EqualUnmodifiableMapView) return _eventTypeCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_eventTypeCounts);
}

 final  Map<String, int> _deviceTypeCounts;
@override Map<String, int> get deviceTypeCounts {
  if (_deviceTypeCounts is EqualUnmodifiableMapView) return _deviceTypeCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_deviceTypeCounts);
}


/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsOverviewCopyWith<_AnalyticsOverview> get copyWith => __$AnalyticsOverviewCopyWithImpl<_AnalyticsOverview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsOverview&&const DeepCollectionEquality().equals(other._scansLast30Days, _scansLast30Days)&&const DeepCollectionEquality().equals(other._mostViewedProducts, _mostViewedProducts)&&const DeepCollectionEquality().equals(other._eventTypeCounts, _eventTypeCounts)&&const DeepCollectionEquality().equals(other._deviceTypeCounts, _deviceTypeCounts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scansLast30Days),const DeepCollectionEquality().hash(_mostViewedProducts),const DeepCollectionEquality().hash(_eventTypeCounts),const DeepCollectionEquality().hash(_deviceTypeCounts));

@override
String toString() {
  return 'AnalyticsOverview(scansLast30Days: $scansLast30Days, mostViewedProducts: $mostViewedProducts, eventTypeCounts: $eventTypeCounts, deviceTypeCounts: $deviceTypeCounts)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsOverviewCopyWith<$Res> implements $AnalyticsOverviewCopyWith<$Res> {
  factory _$AnalyticsOverviewCopyWith(_AnalyticsOverview value, $Res Function(_AnalyticsOverview) _then) = __$AnalyticsOverviewCopyWithImpl;
@override @useResult
$Res call({
 List<int> scansLast30Days, List<ProductViewCount> mostViewedProducts, Map<String, int> eventTypeCounts, Map<String, int> deviceTypeCounts
});




}
/// @nodoc
class __$AnalyticsOverviewCopyWithImpl<$Res>
    implements _$AnalyticsOverviewCopyWith<$Res> {
  __$AnalyticsOverviewCopyWithImpl(this._self, this._then);

  final _AnalyticsOverview _self;
  final $Res Function(_AnalyticsOverview) _then;

/// Create a copy of AnalyticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scansLast30Days = null,Object? mostViewedProducts = null,Object? eventTypeCounts = null,Object? deviceTypeCounts = null,}) {
  return _then(_AnalyticsOverview(
scansLast30Days: null == scansLast30Days ? _self._scansLast30Days : scansLast30Days // ignore: cast_nullable_to_non_nullable
as List<int>,mostViewedProducts: null == mostViewedProducts ? _self._mostViewedProducts : mostViewedProducts // ignore: cast_nullable_to_non_nullable
as List<ProductViewCount>,eventTypeCounts: null == eventTypeCounts ? _self._eventTypeCounts : eventTypeCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deviceTypeCounts: null == deviceTypeCounts ? _self._deviceTypeCounts : deviceTypeCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
