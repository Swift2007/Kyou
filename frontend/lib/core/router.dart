// Responsibility: Defines go_router routes and redirects based on auth state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/entries/entries_list_screen.dart';
import '../features/entries/entry.dart';
import '../features/entries/entry_editor_screen.dart';
import '../features/onboarding/onboarding_flow_screen.dart';
import '../features/welcome/journal_welcome_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: auth.authStateNotifier,
    redirect: (context, state) {
      final isLoggedIn = auth.session != null;
      final location = state.matchedLocation;
      final isLandingOrAuth =
          location == '/welcome' || location == '/login' || location == '/signup';
      final isOnboarding = location == '/onboarding';

      if (!isLoggedIn && !isLandingOrAuth && !isOnboarding) {
        return '/welcome';
      }
      // New accounts are routed to /onboarding after signup; keep /signup reachable
      // so that navigation can complete before/alongside auth-state refresh.
      if (isLoggedIn && (location == '/welcome' || location == '/login')) {
        return '/entries';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => JournalWelcomeScreen(
          onStartJournaling: () => context.go('/signup'),
          onLogIn: () => context.go('/login'),
        ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingFlowScreen(
          onGetStarted: () => context.go('/entries'),
          onSkipped: () => context.go('/entries'),
          onFinished: () => context.go('/entries'),
        ),
      ),
      GoRoute(path: '/entries', builder: (context, state) => const EntriesListScreen()),
      GoRoute(
        path: '/entries/new',
        builder: (context, state) => const EntryEditorScreen(),
      ),
      GoRoute(
        path: '/entries/edit',
        builder: (context, state) => EntryEditorScreen(
          entry: state.extra as Entry?,
        ),
      ),
    ],
  );
});
