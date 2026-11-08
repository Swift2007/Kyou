// Responsibility: Defines go_router routes and redirects based on auth state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/entries/entries_list_screen.dart';
import '../features/entries/entry.dart';
import '../features/entries/entry_editor_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/onboarding/onboarding_flow_screen.dart';
import '../features/welcome/journal_welcome_screen.dart';

/// Decides where a request for [location] should go.
///
/// Returns `null` when the requested location is allowed. Kept as a pure
/// function so the routing rules can be tested without Supabase or widgets.
String? resolveAuthRedirect({
  required String location,
  required bool isLoggedIn,
  required bool needsOnboarding,
}) {
  final isAuthEntry =
      location == '/welcome' || location == '/login' || location == '/signup';
  final isOnboarding = location == '/onboarding';

  if (!isLoggedIn) {
    return isAuthEntry ? null : '/welcome';
  }

  // Any signed-in user who has not finished onboarding goes there first.
  if (needsOnboarding) {
    return isOnboarding ? null : '/onboarding';
  }

  // Finished onboarding: keep them out of the auth/onboarding screens.
  if (isAuthEntry || isOnboarding) {
    return '/home';
  }
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: auth.authStateNotifier,
    redirect: (context, state) => resolveAuthRedirect(
      location: state.matchedLocation,
      isLoggedIn: auth.session != null,
      needsOnboarding: !auth.hasCompletedOnboarding,
    ),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => JournalWelcomeScreen(
          onStartJournaling: () => context.go('/signup'),
          onLogIn: () => context.go('/login'),
        ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingFlowScreen(
          onGetStarted: () => context.go('/home'),
          onSkipped: () => context.go('/home'),
          onFinished: () => context.go('/home'),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: '/entries',
        builder: (context, state) => const EntriesListScreen(),
      ),
      GoRoute(
        path: '/entries/new',
        builder: (context, state) => const EntryEditorScreen(),
      ),
      GoRoute(
        path: '/entries/edit',
        builder: (context, state) =>
            EntryEditorScreen(entry: state.extra as Entry?),
      ),
    ],
  );
});
