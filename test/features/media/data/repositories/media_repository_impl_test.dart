import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_ar_platform/core/utilities/failure.dart';
import 'package:qr_ar_platform/features/media/data/repositories/media_repository_impl.dart';
import 'package:qr_ar_platform/features/media/domain/entities/media_asset.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient client;
  late MediaRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    repository = MediaRepositoryImpl(client);
  });

  test('listForProduct maps a thrown exception to ServerFailure', () async {
    when(() => client.from(any())).thenThrow(Exception('network down'));

    final result = await repository.listForProduct('prod-1');

    expect(result.isLeft(), isTrue);
    result.match((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('expected Left'));
  });

  test('upload maps a thrown exception to ServerFailure', () async {
    when(() => client.storage).thenThrow(Exception('storage unavailable'));

    final result = await repository.upload(
      productId: 'prod-1',
      fileName: 'photo.jpg',
      bytes: Uint8List.fromList([1, 2, 3]),
      extension: 'jpg',
    );

    expect(result.isLeft(), isTrue);
  });

  test('delete maps a thrown exception to ServerFailure', () async {
    when(() => client.storage).thenThrow(Exception('storage unavailable'));

    final media = MediaAsset(
      id: 'media-1',
      productId: 'prod-1',
      type: 'image',
      filePath: 'prod-1/photo.jpg',
      status: 'published',
      isDeleted: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    final result = await repository.delete(media);

    expect(result.isLeft(), isTrue);
  });
}
