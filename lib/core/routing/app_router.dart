import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/controllers/auth_providers.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/categories/presentation/pages/category_form_page.dart';
import '../../features/categories/presentation/pages/category_list_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../features/products/presentation/pages/public_product_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../../shared/presentation/public_landing_page.dart';
import '../widgets/admin_shell.dart';
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
      GoRoute(path: '/scan', builder: (context, state) => const ScannerPage()),
      GoRoute(
        path: '/view/:productId',
        builder: (context, state) => PublicProductPage(
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
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/admin/products',
            builder: (context, state) => const ProductListPage(),
          ),
          GoRoute(
            path: '/admin/products/new',
            builder: (context, state) => const ProductFormPage(),
          ),
          GoRoute(
            path: '/admin/products/:id/edit',
            builder: (context, state) =>
                ProductFormPage(productId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/admin/categories',
            builder: (context, state) => const CategoryListPage(),
          ),
          GoRoute(
            path: '/admin/categories/new',
            builder: (context, state) => const CategoryFormPage(),
          ),
          GoRoute(
            path: '/admin/categories/:id/edit',
            builder: (context, state) =>
                CategoryFormPage(categoryId: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
});
