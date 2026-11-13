// Responsibility: Defines go_router routes and redirects based on auth state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/entries/entries_list_screen.dart';
import '../features/journal_editor/journal_editor_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/journal/create_journal_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/onboarding/onboarding_flow_screen.dart';
import '../features/preference/preference_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/about/about_screen.dart';
import '../features/language/language_screen.dart';
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
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/create-journal',
        builder: (context, state) => const CreateJournalScreen(),
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
        path: '/preference',
        builder: (context, state) => const PreferenceScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/journal',
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
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
        builder: (context, state) => const JournalEditorScreen(),
      ),
      GoRoute(
        path: '/entries/edit',
        builder: (context, state) => const JournalEditorScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
      ),
    ],
  );
});
