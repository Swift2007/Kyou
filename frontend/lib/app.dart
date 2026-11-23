// Responsibility: Builds the root MaterialApp with the router and theme.
// Supabase is initialized after the first frame so the splash screen paints
// immediately on weak devices instead of blocking startup.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/splash_screen.dart';
import 'core/env.dart';
import 'core/router.dart';
import 'core/theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool _supabaseReady = false;
  bool _initializing = true;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    // Initialize Supabase after the first frame so the splash screen appears
    // immediately. The router (and thus AuthRepository) is only built once
    // _supabaseReady is true, so Supabase.instance.client is expected to be
    // available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSupabase());
  }

  Future<void> _initSupabase({bool isRetry = false}) async {
    if (!mounted) return;
    setState(() {
      _initializing = true;
      _initError = null;
      if (isRetry) _supabaseReady = false;
    });

    try {
      // If already initialized (e.g. retry after partial/previous init), avoid
      // re-initializing unnecessarily.
      try {
        Supabase.instance.client;
        if (mounted) {
          setState(() {
            _supabaseReady = true;
            _initializing = false;
          });
        }
        return;
      } catch (_) {
        // Not initialized yet; proceed.
      }

      await Supabase.initialize(
        url: Env.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: Env.supabasePublishableKey,
      ).timeout(const Duration(seconds: 12));

      if (mounted) {
        setState(() {
          _supabaseReady = true;
          _initializing = false;
        });
      }
    } catch (e, stack) {
      debugPrint('Supabase init failed: $e');
      debugPrintStack(stackTrace: stack);

      // If initialization completed despite a wrapped/timeout edge case, allow
      // the app to continue rather than staying stuck.
      var instanceAvailable = false;
      try {
        Supabase.instance.client;
        instanceAvailable = true;
      } catch (_) {
        instanceAvailable = false;
      }

      if (!mounted) return;
      setState(() {
        _supabaseReady = instanceAvailable;
        _initializing = false;
        _initError = instanceAvailable ? null : e;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    if (!_supabaseReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: _StartupErrorScreen(
          error: _initError,
          onRetry: () => _initSupabase(isRetry: true),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Kyou',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = error == null
        ? "Couldn't start the app. Please try again."
        : "Couldn't connect to services right now. Check your connection and try again.";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Kyou', style: AppTextStyles.headline(fontSize: 32)),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                  if (kDebugMode && error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      '$error',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
