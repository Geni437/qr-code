// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotspot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hotspot {

 String get id; String get productId; String get modelId; String? get mediaId; String get title; String? get description; double get positionX; double get positionY; double get positionZ; String? get linkUrl; String? get animationName; String get status; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Hotspot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotspotCopyWith<Hotspot> get copyWith => _$HotspotCopyWithImpl<Hotspot>(this as Hotspot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hotspot&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.positionZ, positionZ) || other.positionZ == positionZ)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&(identical(other.animationName, animationName) || other.animationName == animationName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,modelId,mediaId,title,description,positionX,positionY,positionZ,linkUrl,animationName,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'Hotspot(id: $id, productId: $productId, modelId: $modelId, mediaId: $mediaId, title: $title, description: $description, positionX: $positionX, positionY: $positionY, positionZ: $positionZ, linkUrl: $linkUrl, animationName: $animationName, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HotspotCopyWith<$Res>  {
  factory $HotspotCopyWith(Hotspot value, $Res Function(Hotspot) _then) = _$HotspotCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String modelId, String? mediaId, String title, String? description, double positionX, double positionY, double positionZ, String? linkUrl, String? animationName, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$HotspotCopyWithImpl<$Res>
    implements $HotspotCopyWith<$Res> {
  _$HotspotCopyWithImpl(this._self, this._then);

  final Hotspot _self;
  final $Res Function(Hotspot) _then;

/// Create a copy of Hotspot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? modelId = null,Object? mediaId = freezed,Object? title = null,Object? description = freezed,Object? positionX = null,Object? positionY = null,Object? positionZ = null,Object? linkUrl = freezed,Object? animationName = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,positionZ: null == positionZ ? _self.positionZ : positionZ // ignore: cast_nullable_to_non_nullable
as double,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,animationName: freezed == animationName ? _self.animationName : animationName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Hotspot].
extension HotspotPatterns on Hotspot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hotspot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hotspot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hotspot value)  $default,){
final _that = this;
switch (_that) {
case _Hotspot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hotspot value)?  $default,){
final _that = this;
switch (_that) {
case _Hotspot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String modelId,  String? mediaId,  String title,  String? description,  double positionX,  double positionY,  double positionZ,  String? linkUrl,  String? animationName,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hotspot() when $default != null:
return $default(_that.id,_that.productId,_that.modelId,_that.mediaId,_that.title,_that.description,_that.positionX,_that.positionY,_that.positionZ,_that.linkUrl,_that.animationName,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String modelId,  String? mediaId,  String title,  String? description,  double positionX,  double positionY,  double positionZ,  String? linkUrl,  String? animationName,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Hotspot():
return $default(_that.id,_that.productId,_that.modelId,_that.mediaId,_that.title,_that.description,_that.positionX,_that.positionY,_that.positionZ,_that.linkUrl,_that.animationName,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String modelId,  String? mediaId,  String title,  String? description,  double positionX,  double positionY,  double positionZ,  String? linkUrl,  String? animationName,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Hotspot() when $default != null:
return $default(_that.id,_that.productId,_that.modelId,_that.mediaId,_that.title,_that.description,_that.positionX,_that.positionY,_that.positionZ,_that.linkUrl,_that.animationName,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Hotspot extends Hotspot {
  const _Hotspot({required this.id, required this.productId, required this.modelId, this.mediaId, required this.title, this.description, required this.positionX, required this.positionY, required this.positionZ, this.linkUrl, this.animationName, required this.status, required this.isDeleted, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String productId;
@override final  String modelId;
@override final  String? mediaId;
@override final  String title;
@override final  String? description;
@override final  double positionX;
@override final  double positionY;
@override final  double positionZ;
@override final  String? linkUrl;
@override final  String? animationName;
@override final  String status;
@override final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Hotspot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotspotCopyWith<_Hotspot> get copyWith => __$HotspotCopyWithImpl<_Hotspot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hotspot&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.positionZ, positionZ) || other.positionZ == positionZ)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&(identical(other.animationName, animationName) || other.animationName == animationName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,modelId,mediaId,title,description,positionX,positionY,positionZ,linkUrl,animationName,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'Hotspot(id: $id, productId: $productId, modelId: $modelId, mediaId: $mediaId, title: $title, description: $description, positionX: $positionX, positionY: $positionY, positionZ: $positionZ, linkUrl: $linkUrl, animationName: $animationName, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HotspotCopyWith<$Res> implements $HotspotCopyWith<$Res> {
  factory _$HotspotCopyWith(_Hotspot value, $Res Function(_Hotspot) _then) = __$HotspotCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String modelId, String? mediaId, String title, String? description, double positionX, double positionY, double positionZ, String? linkUrl, String? animationName, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$HotspotCopyWithImpl<$Res>
    implements _$HotspotCopyWith<$Res> {
  __$HotspotCopyWithImpl(this._self, this._then);

  final _Hotspot _self;
  final $Res Function(_Hotspot) _then;

/// Create a copy of Hotspot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? modelId = null,Object? mediaId = freezed,Object? title = null,Object? description = freezed,Object? positionX = null,Object? positionY = null,Object? positionZ = null,Object? linkUrl = freezed,Object? animationName = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Hotspot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,positionZ: null == positionZ ? _self.positionZ : positionZ // ignore: cast_nullable_to_non_nullable
as double,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,animationName: freezed == animationName ? _self.animationName : animationName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
