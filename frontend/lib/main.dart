// Responsibility: Bootstraps Flutter, validates config, and runs the app.
// Supabase is initialized inside App after the first frame so the splash
// screen appears immediately on weak devices instead of blocking startup.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Env.isConfigured) {
    runApp(MissingConfigApp(missingKeys: Env.missingKeys));
    return;
  }

  runApp(const ProviderScope(child: App()));
}

class MissingConfigApp extends StatelessWidget {
  const MissingConfigApp({super.key, required this.missingKeys});

  final List<String> missingKeys;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.settings_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'Configuration required',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The app cannot start because required configuration values are missing.',
                    ),
                    const SizedBox(height: 12),
                    Text('Missing keys: ${missingKeys.join(', ')}'),
                    const SizedBox(height: 16),
                    const SelectableText(
                      'Run with:\n'
                      'flutter run --dart-define-from-file=env.json\n\n'
                      'Use env.json.example as a template. Do not commit env.json.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
