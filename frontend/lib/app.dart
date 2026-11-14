// Responsibility: Builds the root MaterialApp with the router and theme.
// Supabase is initialized after the first frame so the splash screen paints
// immediately on weak devices instead of blocking startup.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize Supabase after the first frame so the splash screen appears
    // immediately. The router (and thus AuthRepository) is only built once
    // _supabaseReady is true, so Supabase.instance.client is always valid.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSupabase());
  }

  Future<void> _initSupabase() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: Env.supabasePublishableKey,
    );
    if (mounted) {
      setState(() => _supabaseReady = true);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_supabaseReady) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
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
