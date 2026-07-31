import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<List<Product>>> list({
    int page = 0,
    int pageSize = 20,
    String? search,
    String? categoryId,
    String? status,
  }) async {
    try {
      var query = _client
          .from(SupabaseTables.products)
          .select()
          .eq('is_deleted', false);

      if (status != null) {
        query = query.eq('status', status);
      }
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      if (search != null && search.trim().isNotEmpty) {
        query = query.ilike('name', '%${search.trim()}%');
      }

      final from = page * pageSize;
      final to = from + pageSize - 1;
      final rows = await query.order('created_at', ascending: false).range(from, to);

      return Right(
        (rows as List)
            .map((row) => Product.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> getById(String id) async {
    try {
      final row = await _client
          .from(SupabaseTables.products)
          .select()
          .eq('id', id)
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> create({
    required String name,
    required String slug,
    String? description,
    String? categoryId,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? version,
    List<String> tags = const [],
    required String status,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.products)
          .insert({
            'name': name,
            'slug': slug,
            'description': description,
            'category_id': categoryId,
            'manufacturer': manufacturer,
            'model_number': modelNumber,
            'serial_number': serialNumber,
            'version': version,
            'tags': tags,
            'status': status,
            'created_by': _userId,
            'updated_by': _userId,
          })
          .select()
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> update({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? categoryId,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? version,
    List<String> tags = const [],
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.products)
          .update({
            'name': name,
            'slug': slug,
            'description': description,
            'category_id': categoryId,
            'manufacturer': manufacturer,
            'model_number': modelNumber,
            'serial_number': serialNumber,
            'version': version,
            'tags': tags,
            'updated_by': _userId,
          })
          .eq('id', id)
          .select()
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> updateImages({
    required String id,
    String? thumbnailUrl,
    String? coverImageUrl,
  }) async {
    try {
      final payload = <String, dynamic>{'updated_by': _userId};
      if (thumbnailUrl != null) payload['thumbnail_url'] = thumbnailUrl;
      if (coverImageUrl != null) payload['cover_image_url'] = coverImageUrl;

      final row = await _client
          .from(SupabaseTables.products)
          .update(payload)
          .eq('id', id)
          .select()
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> duplicate(String id) async {
    try {
      final source = await _client
          .from(SupabaseTables.products)
          .select()
          .eq('id', id)
          .single();

      final copy = Map<String, dynamic>.from(source)
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at')
        ..['name'] = '${source['name']} (Copy)'
        ..['slug'] = '${source['slug']}-copy-${DateTime.now().millisecondsSinceEpoch}'
        ..['status'] = 'draft'
        ..['created_by'] = _userId
        ..['updated_by'] = _userId;

      final row = await _client
          .from(SupabaseTables.products)
          .insert(copy)
          .select()
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Product>> setStatus({
    required String id,
    required String status,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.products)
          .update({'status': status, 'updated_by': _userId})
          .eq('id', id)
          .select()
          .single();
      return Right(Product.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> softDelete(String id) async {
    try {
      await _client
          .from(SupabaseTables.products)
          .update({'is_deleted': true, 'updated_by': _userId})
          .eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
