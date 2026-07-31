import 'package:fpdart/fpdart.dart';

import '../../../../core/utilities/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  /// Non-deleted categories, newest first. Small enough in practice (an
  /// admin-authored list, not user content) that pagination isn't needed.
  Future<Result<List<Category>>> list();

  Future<Result<Category>> create({
    required String name,
    required String slug,
    String? description,
    String? parentId,
    required String status,
  });

  Future<Result<Category>> update({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
  });

  Future<Result<Category>> setStatus({required String id, required String status});

  Future<Result<Unit>> softDelete(String id);
}
