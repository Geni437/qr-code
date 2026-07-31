import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/media_repository_impl.dart';
import '../../domain/repositories/media_repository.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepositoryImpl(ref.watch(supabaseClientProvider));
});
