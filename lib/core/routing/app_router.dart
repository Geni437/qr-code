import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/controllers/auth_providers.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../shared/presentation/product_view_placeholder_page.dart';
import '../../shared/presentation/public_landing_page.dart';
import 'go_router_refresh_stream.dart';

const _adminAuthRoutes = {'/admin/login', '/admin/forgot-password'};

final routerProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final location = state.matchedLocation;
      final goingToAdminAuth = _adminAuthRoutes.contains(location);
      final goingToAdminArea = location.startsWith('/admin');

      if (goingToAdminArea && !goingToAdminAuth && !isLoggedIn) {
        return '/admin/login';
      }
      if (goingToAdminAuth && isLoggedIn) {
        return '/admin/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const PublicLandingPage()),
      GoRoute(
        path: '/view/:productId',
        builder: (context, state) => ProductViewPlaceholderPage(
          productId: state.pathParameters['productId']!,
        ),
      ),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/admin/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
});
