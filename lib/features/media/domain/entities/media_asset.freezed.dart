// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaAsset {

 String get id; String get productId; String get type; String get filePath; String? get fileName; String? get mimeType; int? get fileSizeBytes; String get status; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<MediaAsset> get copyWith => _$MediaAssetCopyWithImpl<MediaAsset>(this as MediaAsset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,type,filePath,fileName,mimeType,fileSizeBytes,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'MediaAsset(id: $id, productId: $productId, type: $type, filePath: $filePath, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MediaAssetCopyWith<$Res>  {
  factory $MediaAssetCopyWith(MediaAsset value, $Res Function(MediaAsset) _then) = _$MediaAssetCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String type, String filePath, String? fileName, String? mimeType, int? fileSizeBytes, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MediaAssetCopyWithImpl<$Res>
    implements $MediaAssetCopyWith<$Res> {
  _$MediaAssetCopyWithImpl(this._self, this._then);

  final MediaAsset _self;
  final $Res Function(MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? filePath = null,Object? fileName = freezed,Object? mimeType = freezed,Object? fileSizeBytes = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAsset].
extension MediaAssetPatterns on MediaAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAsset value)  $default,){
final _that = this;
switch (_that) {
case _MediaAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAsset value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String type,  String filePath,  String? fileName,  String? mimeType,  int? fileSizeBytes,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.filePath,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String type,  String filePath,  String? fileName,  String? mimeType,  int? fileSizeBytes,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MediaAsset():
return $default(_that.id,_that.productId,_that.type,_that.filePath,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String type,  String filePath,  String? fileName,  String? mimeType,  int? fileSizeBytes,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.filePath,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MediaAsset extends MediaAsset {
  const _MediaAsset({required this.id, required this.productId, required this.type, required this.filePath, this.fileName, this.mimeType, this.fileSizeBytes, required this.status, required this.isDeleted, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String productId;
@override final  String type;
@override final  String filePath;
@override final  String? fileName;
@override final  String? mimeType;
@override final  int? fileSizeBytes;
@override final  String status;
@override final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetCopyWith<_MediaAsset> get copyWith => __$MediaAssetCopyWithImpl<_MediaAsset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,type,filePath,fileName,mimeType,fileSizeBytes,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'MediaAsset(id: $id, productId: $productId, type: $type, filePath: $filePath, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetCopyWith<$Res> implements $MediaAssetCopyWith<$Res> {
  factory _$MediaAssetCopyWith(_MediaAsset value, $Res Function(_MediaAsset) _then) = __$MediaAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String type, String filePath, String? fileName, String? mimeType, int? fileSizeBytes, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MediaAssetCopyWithImpl<$Res>
    implements _$MediaAssetCopyWith<$Res> {
  __$MediaAssetCopyWithImpl(this._self, this._then);

  final _MediaAsset _self;
  final $Res Function(_MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? filePath = null,Object? fileName = freezed,Object? mimeType = freezed,Object? fileSizeBytes = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MediaAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
