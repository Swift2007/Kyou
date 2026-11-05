import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env.dart';

Future<void> main() async {
  // Fail fast with a clear message: without these values Supabase would
  // crash later with an error that says nothing about the real problem.
  if (!Env.isConfigured) {
    throw Exception(
      'Missing config. Copy env.json.example to env.json, fill in the '
      'values, then run:\n'
      'flutter run --dart-define-from-file=env.json',
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Supabase must be ready before any screen or provider touches it.
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  // ProviderScope is Riverpod's root: it gives every screen access to
  // its ViewModels.
  runApp(const ProviderScope(child: JournalApp()));
}
