import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/repositories/model_repository_impl.dart';
import '../../domain/repositories/model_repository.dart';

final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  return ModelRepositoryImpl(ref.watch(supabaseClientProvider));
});
