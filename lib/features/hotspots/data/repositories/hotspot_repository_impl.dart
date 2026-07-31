import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/failure.dart';
import '../../../../core/utilities/result.dart';
import '../../domain/entities/hotspot.dart';
import '../../domain/repositories/hotspot_repository.dart';

class HotspotRepositoryImpl implements HotspotRepository {
  HotspotRepositoryImpl(this._client);

  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  @override
  Future<Result<List<Hotspot>>> listForModel(String modelId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.hotspots)
          .select()
          .eq('model_id', modelId)
          .eq('is_deleted', false)
          .order('created_at', ascending: false);
      return Right(
        (rows as List)
            .map((row) => Hotspot.fromRow(row as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Hotspot>> create({
    required String productId,
    required String modelId,
    String? mediaId,
    required String title,
    String? description,
    required double positionX,
    required double positionY,
    required double positionZ,
    String? linkUrl,
    String? animationName,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.hotspots)
          .insert({
            'product_id': productId,
            'model_id': modelId,
            'media_id': mediaId,
            'title': title,
            'description': description,
            'position_x': positionX,
            'position_y': positionY,
            'position_z': positionZ,
            'link_url': linkUrl,
            'animation_name': animationName,
            'status': 'published',
            'created_by': _userId,
            'updated_by': _userId,
          })
          .select()
          .single();
      return Right(Hotspot.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Hotspot>> update({
    required String id,
    String? mediaId,
    required String title,
    String? description,
    String? linkUrl,
    String? animationName,
  }) async {
    try {
      final row = await _client
          .from(SupabaseTables.hotspots)
          .update({
            'media_id': mediaId,
            'title': title,
            'description': description,
            'link_url': linkUrl,
            'animation_name': animationName,
            'updated_by': _userId,
          })
          .eq('id', id)
          .select()
          .single();
      return Right(Hotspot.fromRow(row));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    try {
      await _client.from(SupabaseTables.hotspots).delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
