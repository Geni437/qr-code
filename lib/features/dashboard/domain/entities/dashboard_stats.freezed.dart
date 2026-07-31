// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardStats {

 int get totalProducts; int get activeProducts; int get totalCategories; int get totalModels;// Proxy for "Total QR Codes": each published product gets one QR code,
// but QR generation itself is Phase 3, so this is the closest real
// number available today.
 int get totalQrCodes; int get totalScans; int get storageUsageBytes; List<Product> get recentUploads;/// Scan counts for the last 7 days, oldest first (index 6 = today).
 List<int> get scansLast7Days; bool get isHealthy;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.totalCategories, totalCategories) || other.totalCategories == totalCategories)&&(identical(other.totalModels, totalModels) || other.totalModels == totalModels)&&(identical(other.totalQrCodes, totalQrCodes) || other.totalQrCodes == totalQrCodes)&&(identical(other.totalScans, totalScans) || other.totalScans == totalScans)&&(identical(other.storageUsageBytes, storageUsageBytes) || other.storageUsageBytes == storageUsageBytes)&&const DeepCollectionEquality().equals(other.recentUploads, recentUploads)&&const DeepCollectionEquality().equals(other.scansLast7Days, scansLast7Days)&&(identical(other.isHealthy, isHealthy) || other.isHealthy == isHealthy));
}


@override
int get hashCode => Object.hash(runtimeType,totalProducts,activeProducts,totalCategories,totalModels,totalQrCodes,totalScans,storageUsageBytes,const DeepCollectionEquality().hash(recentUploads),const DeepCollectionEquality().hash(scansLast7Days),isHealthy);

@override
String toString() {
  return 'DashboardStats(totalProducts: $totalProducts, activeProducts: $activeProducts, totalCategories: $totalCategories, totalModels: $totalModels, totalQrCodes: $totalQrCodes, totalScans: $totalScans, storageUsageBytes: $storageUsageBytes, recentUploads: $recentUploads, scansLast7Days: $scansLast7Days, isHealthy: $isHealthy)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
 int totalProducts, int activeProducts, int totalCategories, int totalModels, int totalQrCodes, int totalScans, int storageUsageBytes, List<Product> recentUploads, List<int> scansLast7Days, bool isHealthy
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalProducts = null,Object? activeProducts = null,Object? totalCategories = null,Object? totalModels = null,Object? totalQrCodes = null,Object? totalScans = null,Object? storageUsageBytes = null,Object? recentUploads = null,Object? scansLast7Days = null,Object? isHealthy = null,}) {
  return _then(_self.copyWith(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,totalCategories: null == totalCategories ? _self.totalCategories : totalCategories // ignore: cast_nullable_to_non_nullable
as int,totalModels: null == totalModels ? _self.totalModels : totalModels // ignore: cast_nullable_to_non_nullable
as int,totalQrCodes: null == totalQrCodes ? _self.totalQrCodes : totalQrCodes // ignore: cast_nullable_to_non_nullable
as int,totalScans: null == totalScans ? _self.totalScans : totalScans // ignore: cast_nullable_to_non_nullable
as int,storageUsageBytes: null == storageUsageBytes ? _self.storageUsageBytes : storageUsageBytes // ignore: cast_nullable_to_non_nullable
as int,recentUploads: null == recentUploads ? _self.recentUploads : recentUploads // ignore: cast_nullable_to_non_nullable
as List<Product>,scansLast7Days: null == scansLast7Days ? _self.scansLast7Days : scansLast7Days // ignore: cast_nullable_to_non_nullable
as List<int>,isHealthy: null == isHealthy ? _self.isHealthy : isHealthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStats].
extension DashboardStatsPatterns on DashboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStats value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalProducts,  int activeProducts,  int totalCategories,  int totalModels,  int totalQrCodes,  int totalScans,  int storageUsageBytes,  List<Product> recentUploads,  List<int> scansLast7Days,  bool isHealthy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.totalProducts,_that.activeProducts,_that.totalCategories,_that.totalModels,_that.totalQrCodes,_that.totalScans,_that.storageUsageBytes,_that.recentUploads,_that.scansLast7Days,_that.isHealthy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalProducts,  int activeProducts,  int totalCategories,  int totalModels,  int totalQrCodes,  int totalScans,  int storageUsageBytes,  List<Product> recentUploads,  List<int> scansLast7Days,  bool isHealthy)  $default,) {final _that = this;
switch (_that) {
case _DashboardStats():
return $default(_that.totalProducts,_that.activeProducts,_that.totalCategories,_that.totalModels,_that.totalQrCodes,_that.totalScans,_that.storageUsageBytes,_that.recentUploads,_that.scansLast7Days,_that.isHealthy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalProducts,  int activeProducts,  int totalCategories,  int totalModels,  int totalQrCodes,  int totalScans,  int storageUsageBytes,  List<Product> recentUploads,  List<int> scansLast7Days,  bool isHealthy)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.totalProducts,_that.activeProducts,_that.totalCategories,_that.totalModels,_that.totalQrCodes,_that.totalScans,_that.storageUsageBytes,_that.recentUploads,_that.scansLast7Days,_that.isHealthy);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardStats implements DashboardStats {
  const _DashboardStats({required this.totalProducts, required this.activeProducts, required this.totalCategories, required this.totalModels, required this.totalQrCodes, required this.totalScans, required this.storageUsageBytes, required final  List<Product> recentUploads, required final  List<int> scansLast7Days, required this.isHealthy}): _recentUploads = recentUploads,_scansLast7Days = scansLast7Days;
  

@override final  int totalProducts;
@override final  int activeProducts;
@override final  int totalCategories;
@override final  int totalModels;
// Proxy for "Total QR Codes": each published product gets one QR code,
// but QR generation itself is Phase 3, so this is the closest real
// number available today.
@override final  int totalQrCodes;
@override final  int totalScans;
@override final  int storageUsageBytes;
 final  List<Product> _recentUploads;
@override List<Product> get recentUploads {
  if (_recentUploads is EqualUnmodifiableListView) return _recentUploads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentUploads);
}

/// Scan counts for the last 7 days, oldest first (index 6 = today).
 final  List<int> _scansLast7Days;
/// Scan counts for the last 7 days, oldest first (index 6 = today).
@override List<int> get scansLast7Days {
  if (_scansLast7Days is EqualUnmodifiableListView) return _scansLast7Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scansLast7Days);
}

@override final  bool isHealthy;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.totalCategories, totalCategories) || other.totalCategories == totalCategories)&&(identical(other.totalModels, totalModels) || other.totalModels == totalModels)&&(identical(other.totalQrCodes, totalQrCodes) || other.totalQrCodes == totalQrCodes)&&(identical(other.totalScans, totalScans) || other.totalScans == totalScans)&&(identical(other.storageUsageBytes, storageUsageBytes) || other.storageUsageBytes == storageUsageBytes)&&const DeepCollectionEquality().equals(other._recentUploads, _recentUploads)&&const DeepCollectionEquality().equals(other._scansLast7Days, _scansLast7Days)&&(identical(other.isHealthy, isHealthy) || other.isHealthy == isHealthy));
}


@override
int get hashCode => Object.hash(runtimeType,totalProducts,activeProducts,totalCategories,totalModels,totalQrCodes,totalScans,storageUsageBytes,const DeepCollectionEquality().hash(_recentUploads),const DeepCollectionEquality().hash(_scansLast7Days),isHealthy);

@override
String toString() {
  return 'DashboardStats(totalProducts: $totalProducts, activeProducts: $activeProducts, totalCategories: $totalCategories, totalModels: $totalModels, totalQrCodes: $totalQrCodes, totalScans: $totalScans, storageUsageBytes: $storageUsageBytes, recentUploads: $recentUploads, scansLast7Days: $scansLast7Days, isHealthy: $isHealthy)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalProducts, int activeProducts, int totalCategories, int totalModels, int totalQrCodes, int totalScans, int storageUsageBytes, List<Product> recentUploads, List<int> scansLast7Days, bool isHealthy
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalProducts = null,Object? activeProducts = null,Object? totalCategories = null,Object? totalModels = null,Object? totalQrCodes = null,Object? totalScans = null,Object? storageUsageBytes = null,Object? recentUploads = null,Object? scansLast7Days = null,Object? isHealthy = null,}) {
  return _then(_DashboardStats(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,totalCategories: null == totalCategories ? _self.totalCategories : totalCategories // ignore: cast_nullable_to_non_nullable
as int,totalModels: null == totalModels ? _self.totalModels : totalModels // ignore: cast_nullable_to_non_nullable
as int,totalQrCodes: null == totalQrCodes ? _self.totalQrCodes : totalQrCodes // ignore: cast_nullable_to_non_nullable
as int,totalScans: null == totalScans ? _self.totalScans : totalScans // ignore: cast_nullable_to_non_nullable
as int,storageUsageBytes: null == storageUsageBytes ? _self.storageUsageBytes : storageUsageBytes // ignore: cast_nullable_to_non_nullable
as int,recentUploads: null == recentUploads ? _self._recentUploads : recentUploads // ignore: cast_nullable_to_non_nullable
as List<Product>,scansLast7Days: null == scansLast7Days ? _self._scansLast7Days : scansLast7Days // ignore: cast_nullable_to_non_nullable
as List<int>,isHealthy: null == isHealthy ? _self.isHealthy : isHealthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
