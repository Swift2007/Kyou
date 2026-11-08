import 'package:flutter_test/flutter_test.dart';

import 'package:journal_app/core/router.dart';

void main() {
  const authEntries = ['/welcome', '/login', '/signup'];
  const protectedRoutes = [
    '/home',
    '/entries',
    '/entries/new',
    '/entries/edit',
  ];

  group('resolveAuthRedirect', () {
    test('signed-out users can only see auth entry screens', () {
      for (final location in authEntries) {
        expect(
          resolveAuthRedirect(
            location: location,
            isLoggedIn: false,
            needsOnboarding: false,
          ),
          isNull,
          reason: '$location should stay reachable while signed out',
        );
      }

      for (final location in [...protectedRoutes, '/onboarding']) {
        expect(
          resolveAuthRedirect(
            location: location,
            isLoggedIn: false,
            needsOnboarding: false,
          ),
          '/welcome',
          reason: '$location should require a session',
        );
      }
    });

    test('new users are sent to onboarding from every other route', () {
      for (final location in [...authEntries, ...protectedRoutes]) {
        expect(
          resolveAuthRedirect(
            location: location,
            isLoggedIn: true,
            needsOnboarding: true,
          ),
          '/onboarding',
          reason: 'signup at $location must not skip onboarding',
        );
      }

      expect(
        resolveAuthRedirect(
          location: '/onboarding',
          isLoggedIn: true,
          needsOnboarding: true,
        ),
        isNull,
      );
    });

    test('completed users skip auth and onboarding screens', () {
      for (final location in [...authEntries, '/onboarding']) {
        expect(
          resolveAuthRedirect(
            location: location,
            isLoggedIn: true,
            needsOnboarding: false,
          ),
          '/home',
          reason: '$location should not be shown after onboarding',
        );
      }

      for (final location in protectedRoutes) {
        expect(
          resolveAuthRedirect(
            location: location,
            isLoggedIn: true,
            needsOnboarding: false,
          ),
          isNull,
          reason: '$location should be reachable after onboarding',
        );
      }
    });
  });
}
