// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get name; String get slug; String? get description; String? get categoryId; String? get manufacturer; String? get modelNumber; String? get serialNumber; String? get version;// Storage path (bucket-relative), not a resolvable URL yet — the
// `thumbnails`/`images` buckets are admin-only in Phase 2. Resolve via
// a signed URL for now; Phase 4 will decide the public retrieval path.
 String? get thumbnailUrl; String? get coverImageUrl; List<String> get tags; String get status; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.version, version) || other.version == version)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,categoryId,manufacturer,modelNumber,serialNumber,version,thumbnailUrl,coverImageUrl,const DeepCollectionEquality().hash(tags),status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'Product(id: $id, name: $name, slug: $slug, description: $description, categoryId: $categoryId, manufacturer: $manufacturer, modelNumber: $modelNumber, serialNumber: $serialNumber, version: $version, thumbnailUrl: $thumbnailUrl, coverImageUrl: $coverImageUrl, tags: $tags, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description, String? categoryId, String? manufacturer, String? modelNumber, String? serialNumber, String? version, String? thumbnailUrl, String? coverImageUrl, List<String> tags, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? categoryId = freezed,Object? manufacturer = freezed,Object? modelNumber = freezed,Object? serialNumber = freezed,Object? version = freezed,Object? thumbnailUrl = freezed,Object? coverImageUrl = freezed,Object? tags = null,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,modelNumber: freezed == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? categoryId,  String? manufacturer,  String? modelNumber,  String? serialNumber,  String? version,  String? thumbnailUrl,  String? coverImageUrl,  List<String> tags,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.categoryId,_that.manufacturer,_that.modelNumber,_that.serialNumber,_that.version,_that.thumbnailUrl,_that.coverImageUrl,_that.tags,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? categoryId,  String? manufacturer,  String? modelNumber,  String? serialNumber,  String? version,  String? thumbnailUrl,  String? coverImageUrl,  List<String> tags,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.categoryId,_that.manufacturer,_that.modelNumber,_that.serialNumber,_that.version,_that.thumbnailUrl,_that.coverImageUrl,_that.tags,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description,  String? categoryId,  String? manufacturer,  String? modelNumber,  String? serialNumber,  String? version,  String? thumbnailUrl,  String? coverImageUrl,  List<String> tags,  String status,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.categoryId,_that.manufacturer,_that.modelNumber,_that.serialNumber,_that.version,_that.thumbnailUrl,_that.coverImageUrl,_that.tags,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.name, required this.slug, this.description, this.categoryId, this.manufacturer, this.modelNumber, this.serialNumber, this.version, this.thumbnailUrl, this.coverImageUrl, required final  List<String> tags, required this.status, required this.isDeleted, required this.createdAt, required this.updatedAt}): _tags = tags,super._();
  

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? categoryId;
@override final  String? manufacturer;
@override final  String? modelNumber;
@override final  String? serialNumber;
@override final  String? version;
// Storage path (bucket-relative), not a resolvable URL yet — the
// `thumbnails`/`images` buckets are admin-only in Phase 2. Resolve via
// a signed URL for now; Phase 4 will decide the public retrieval path.
@override final  String? thumbnailUrl;
@override final  String? coverImageUrl;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String status;
@override final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.version, version) || other.version == version)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,categoryId,manufacturer,modelNumber,serialNumber,version,thumbnailUrl,coverImageUrl,const DeepCollectionEquality().hash(_tags),status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'Product(id: $id, name: $name, slug: $slug, description: $description, categoryId: $categoryId, manufacturer: $manufacturer, modelNumber: $modelNumber, serialNumber: $serialNumber, version: $version, thumbnailUrl: $thumbnailUrl, coverImageUrl: $coverImageUrl, tags: $tags, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description, String? categoryId, String? manufacturer, String? modelNumber, String? serialNumber, String? version, String? thumbnailUrl, String? coverImageUrl, List<String> tags, String status, bool isDeleted, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? categoryId = freezed,Object? manufacturer = freezed,Object? modelNumber = freezed,Object? serialNumber = freezed,Object? version = freezed,Object? thumbnailUrl = freezed,Object? coverImageUrl = freezed,Object? tags = null,Object? status = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,modelNumber: freezed == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
