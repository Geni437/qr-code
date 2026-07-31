import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/media_asset.dart';
import '../../domain/repositories/media_repository.dart';

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'};
const _videoExtensions = {'mp4', 'mov', 'avi', 'webm', 'mkv'};
const _audioExtensions = {'mp3', 'wav', 'ogg', 'm4a'};

class MediaRepositoryImpl implements MediaRepository {
  MediaRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Maps a file extension to the (media `type`, storage bucket) it belongs
  /// in — one bucket per media kind, matching the schema in
  /// SUPABASE_SETUP.md.
  (String type, String bucket) _classify(String? extension) {
    final ext = (extension ?? '').toLowerCase();
    if (_imageExtensions.contains(ext)) return ('image', AppConstants.imagesBucket);
    if (_videoExtensions.contains(ext)) return ('video', AppConstants.videosBucket);
    if (_audioExtensions.contains(ext)) return ('audio', AppConstants.audioBucket);
    if (ext == 'pdf') return ('pdf', AppConstants.documentsBucket);
    if (const {'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'zip'}.contains(ext)) {
      return ('document', AppConstants.documentsBucket);
    }
    return ('other', AppConstants.documentsBucket);
  }

  @override
  Future<Result<List<MediaAsset>>> listForProduct(String productId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.media)
          .select()
          .eq('product_id', productId)
          .eq('is_deleted', false)
          .order('created_at', ascending: false);
      return Right(
        (rows as List)
            .map((row) => MediaAsset.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MediaAsset>> upload({
    required String productId,
    required String fileName,
    required Uint8List bytes,
    required String? extension,
  }) async {
    try {
      final (type, bucket) = _classify(extension);
      final path = '$productId/${DateTime.now().microsecondsSinceEpoch}_$fileName';
      await _client.storage
          .from(bucket)
          .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));

      final row = await _client
          .from(SupabaseTables.media)
          .insert({
            'product_id': productId,
            'type': type,
            'file_path': path,
            'file_name': fileName,
            'file_size_bytes': bytes.length,
            'status': 'published',
            'created_by': _userId,
            'updated_by': _userId,
          })
          .select()
          .single();
      return Right(MediaAsset.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> delete(MediaAsset media) async {
    try {
      final pathParts = media.filePath.split('.');
      final (_, bucket) = _classify(pathParts.length > 1 ? pathParts.last : null);
      await _client.storage.from(bucket).remove([media.filePath]);
      await _client.from(SupabaseTables.media).delete().eq('id', media.id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
