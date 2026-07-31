import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/models/data/repositories/model_repository_impl.dart';
import 'package:qr_ar_platform/features/models/domain/entities/model_asset.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(const FileOptions());
  });

  test('attachUsdz maps a thrown exception to ServerFailure', () async {
    final client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    final storage = MockSupabaseStorageClient();
    final fileApi = MockStorageFileApi();

    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    when(() => client.storage).thenReturn(storage);
    when(() => storage.from(any())).thenReturn(fileApi);
    when(
      () => fileApi.uploadBinary(any(), any(), fileOptions: any(named: 'fileOptions')),
    ).thenThrow(Exception('network down'));

    final repository = ModelRepositoryImpl(client);
    final model = ModelAsset(
      id: 'model-1',
      productId: 'prod-1',
      filePath: 'prod-1/model.glb',
      format: 'glb',
      version: 1,
      status: 'published',
      isDeleted: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    final result = await repository.attachUsdz(
      model: model,
      fileName: 'model.usdz',
      bytes: Uint8List.fromList([1, 2, 3]),
    );

    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });
}
