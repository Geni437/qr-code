// End-to-end smoke test: admin login -> create a category -> create a
// product -> confirm it shows up in the product list.
//
// This is scaffolding for *you* to run, not something verified from this
// environment — it needs a real device/emulator/browser (`flutter test
// integration_test/app_test.dart -d <device>` or `flutter drive`), none of
// which exist here. It also needs a real admin account on whatever Supabase
// project `.env` points at; credentials are passed via --dart-define so
// nothing is hardcoded:
//
//   flutter test integration_test/app_test.dart \
//     --dart-define=TEST_ADMIN_EMAIL=you@example.com \
//     --dart-define=TEST_ADMIN_PASSWORD=your-password \
//     -d chrome
//
// Without those defines the test skips itself with a clear message rather
// than failing confusingly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_ar_platform/main.dart' as app;

const _testEmail = String.fromEnvironment('TEST_ADMIN_EMAIL');
const _testPassword = String.fromEnvironment('TEST_ADMIN_PASSWORD');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('admin can log in, create a category, and create a product', (tester) async {
    if (_testEmail.isEmpty || _testPassword.isEmpty) {
      markTestSkipped(
        'Set TEST_ADMIN_EMAIL/TEST_ADMIN_PASSWORD via --dart-define to run this against a '
        'real Supabase project and admin account.',
      );
      return;
    }

    app.main();
    await tester.pumpAndSettle();

    // The auth-aware redirect (lib/core/routing/app_router.dart) sends an
    // unauthenticated visit to /admin/* straight to /admin/login — get there
    // via the public landing page's own navigation rather than assuming a
    // starting route.
    await tester.tap(find.text('Scan QR Code'));
    await tester.pumpAndSettle();
    // No camera in a headless test runner; the scanner page's manual-entry
    // fallback is used everywhere in this smoke test instead of the camera.

    // Sign in.
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), _testEmail);
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), _testPassword);
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Dashboard'), findsWidgets);

    // Create a category.
    await tester.tap(find.byIcon(Icons.category_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final categoryName = 'Integration Test Category ${DateTime.now().millisecondsSinceEpoch}';
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), categoryName);
    await tester.tap(find.text('Create Category'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text(categoryName), findsOneWidget);

    // Create a product.
    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final productName = 'Integration Test Product ${DateTime.now().millisecondsSinceEpoch}';
    await tester.enterText(find.widgetWithText(TextFormField, 'Product name'), productName);
    await tester.tap(find.text('Create Product'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(find.text(productName), findsOneWidget);
  });
}
