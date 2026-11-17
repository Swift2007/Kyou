// Responsibility: Defines go_router routes, shell navigation, and auth redirects.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/about/about_screen.dart';
import '../features/auth/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/entries/entries_list_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/journal/create_journal_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/journal_editor/journal_editor_screen.dart';
import '../features/language/language_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/onboarding/onboarding_flow_screen.dart';
import '../features/preference/preference_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/welcome/journal_welcome_screen.dart';
import 'widgets/main_shell_scaffold.dart';

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

  if (needsOnboarding) {
    return isOnboarding ? null : '/onboarding';
  }

  if (isAuthEntry || isOnboarding) {
    return '/home';
  }
  return null;
}

CustomTransitionPage<void> _slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final offset = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(curved);
      return SlideTransition(position: offset, child: child);
    },
  );
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
        path: '/onboarding',
        builder: (context, state) => OnboardingFlowScreen(
          onGetStarted: () => context.go('/home'),
          onSkipped: () => context.go('/home'),
          onFinished: () => context.go('/home'),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeDashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: JournalScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/create-journal',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const CreateJournalScreen(),
        ),
      ),
      GoRoute(
        path: '/preference',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const PreferenceScreen(),
        ),
      ),
      GoRoute(
        path: '/insights',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const InsightsScreen(),
        ),
      ),
      GoRoute(
        path: '/entries',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const EntriesListScreen(),
        ),
      ),
      GoRoute(
        path: '/entries/new',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const JournalEditorScreen(),
        ),
      ),
      GoRoute(
        path: '/entries/edit',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const JournalEditorScreen(),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const NotificationScreen(),
        ),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const AboutScreen(),
        ),
      ),
      GoRoute(
        path: '/language',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const LanguageScreen(),
        ),
      ),
    ],
  );
});
