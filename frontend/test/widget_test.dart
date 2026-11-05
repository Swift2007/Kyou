import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:journal_app/features/auth/auth_repository.dart';
import 'package:journal_app/features/auth/login_screen.dart';

// The template test pointed at the old default app, so it was replaced with a
// smoke test for the login screen. Supabase is never initialized in tests, so
// the repository provider is overridden with an offline client that never
// performs network calls.
void main() {
  testWidgets('login screen shows the sign-in form', (WidgetTester tester) async {
    final client = SupabaseClient('http://localhost', 'test-key');
    // The auth client starts a token auto-refresh timer in its constructor,
    // which would outlive the test; stop it so no pending timer is flagged.
    client.auth.stopAutoRefresh();
    final repo = AuthRepository(client);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    expect(find.widgetWithText(FilledButton, 'Log in'), findsOneWidget);
    expect(find.text("Don't have an account? Sign up"), findsOneWidget);

    // Elapse zero test-time so gotrue's zero-duration delay (scheduled by
    // startAutoRefresh) fires; otherwise the test fails on a pending timer.
    await tester.pump(Duration.zero);
  });
}
