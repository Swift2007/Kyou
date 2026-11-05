// Responsibility: Defines go_router routes and redirects based on auth state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/entries/entries_list_screen.dart';
import '../features/entries/entry.dart';
import '../features/entries/entry_editor_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);

  return GoRouter(
    refreshListenable: auth.authStateNotifier,
    redirect: (context, state) {
      final isLoggedIn = auth.session != null;
      final loggingIn =
          state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isLoggedIn && !loggingIn) {
        return '/login';
      }
      if (isLoggedIn && loggingIn) {
        return '/entries';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
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
