import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qr_ar_platform/core/utilities/result.dart';
import 'package:qr_ar_platform/features/authentication/domain/entities/app_user.dart';
import 'package:qr_ar_platform/features/authentication/domain/repositories/auth_repository.dart';
import 'package:qr_ar_platform/features/authentication/presentation/controllers/auth_providers.dart';
import 'package:qr_ar_platform/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:qr_ar_platform/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:qr_ar_platform/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:qr_ar_platform/features/dashboard/presentation/dashboard_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => null;

  @override
  Stream<AppUser?> authStateChanges() => const Stream.empty();

  @override
  Future<Result<AppUser>> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit>> signOut() async => const Right(unit);

  @override
  Future<Result<Unit>> sendPasswordResetEmail({required String email}) async {
    throw UnimplementedError();
  }
}

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<Result<DashboardStats>> getStats() async => const Right(
    DashboardStats(
      totalProducts: 3,
      activeProducts: 2,
      totalCategories: 1,
      totalModels: 1,
      totalQrCodes: 2,
      totalScans: 10,
      storageUsageBytes: 2048,
      recentUploads: [],
      scansLast7Days: [0, 0, 0, 0, 0, 0, 0],
      isHealthy: true,
    ),
  );
}

void main() {
  testWidgets('DashboardPage renders stat tiles from the repository', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          dashboardRepositoryProvider.overrideWithValue(FakeDashboardRepository()),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('Total Products'), findsOneWidget);
    expect(find.text('Operational'), findsOneWidget);
  });
}
