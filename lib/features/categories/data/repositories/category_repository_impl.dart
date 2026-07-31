import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<List<Category>>> list() async {
    try {
      final rows = await _client
          .from(SupabaseTables.categories)
          .select()
          .eq('is_deleted', false)
          .order('created_at', ascending: false);
      return Right(
        (rows as List)
            .map((row) => Category.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Category>> create({
    required String name,
    required String slug,
    String? description,
    String? parentId,
    required String status,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.categories)
          .insert({
            'name': name,
            'slug': slug,
            'description': description,
            'parent_id': parentId,
            'status': status,
            'created_by': _userId,
            'updated_by': _userId,
          })
          .select()
          .single();
      return Right(Category.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Category>> update({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.categories)
          .update({
            'name': name,
            'slug': slug,
            'description': description,
            'parent_id': parentId,
            'updated_by': _userId,
          })
          .eq('id', id)
          .select()
          .single();
      return Right(Category.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Category>> setStatus({
    required String id,
    required String status,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.categories)
          .update({'status': status, 'updated_by': _userId})
          .eq('id', id)
          .select()
          .single();
      return Right(Category.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> softDelete(String id) async {
    try {
      await _client
          .from(SupabaseTables.categories)
          .update({'is_deleted': true, 'updated_by': _userId})
          .eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
