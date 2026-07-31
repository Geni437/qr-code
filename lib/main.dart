import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/config/supabase_config.dart';
import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter web defaults to hash-based URLs (#/admin/login) unless told
  // otherwise — without this, every real path (typed directly, refreshed,
  // or deep-linked from a QR code) just loads the app fresh at its
  // default route, ignoring the actual browser path entirely. A no-op on
  // non-web platforms.
  usePathUrlStrategy();
  // Skip the .env HTTP fetch entirely when --dart-define config was
  // provided at build time — some production web hosts 403 any request
  // for a dotfile, so there's no reason to attempt (and log an error for)
  // a fetch nothing actually needs. See SupabaseConfig's doc comment.
  if (!SupabaseConfig.hasCompileTimeConfig) {
    await dotenv.load(fileName: '.env', isOptional: true);
  }
  await initSupabase();
  runApp(const ProviderScope(child: QrArApp()));
}

class QrArApp extends ConsumerWidget {
  const QrArApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
