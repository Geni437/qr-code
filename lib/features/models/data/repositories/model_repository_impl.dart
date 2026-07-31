import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/model_asset.dart';
import '../../domain/repositories/model_repository.dart';

class ModelRepositoryImpl implements ModelRepository {
  ModelRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<List<ModelAsset>>> listForProduct(String productId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.models)
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false);
      return Right(
        (rows as List)
            .map((row) => ModelAsset.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ModelAsset>> upload({
    required String productId,
    required String fileName,
    required Uint8List bytes,
    required String format,
  }) async {
    try {
      final path = '$productId/${DateTime.now().microsecondsSinceEpoch}_$fileName';
      await _client.storage
          .from(AppConstants.modelsBucket)
          .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));

      final row = await _client
          .from(SupabaseTables.models)
          .insert({
            'product_id': productId,
            'file_path': path,
            'format': format,
            'file_size_bytes': bytes.length,
            'status': 'published',
            'created_by': _userId,
            'updated_by': _userId,
          })
          .select()
          .single();
      return Right(ModelAsset.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> delete(ModelAsset model) async {
    try {
      await _client.storage.from(AppConstants.modelsBucket).remove([model.filePath]);
      await _client.from(SupabaseTables.models).delete().eq('id', model.id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> getSignedUrl(String filePath) async {
    try {
      final url = await _client.storage
          .from(AppConstants.modelsBucket)
          .createSignedUrl(filePath, 60 * 10);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
