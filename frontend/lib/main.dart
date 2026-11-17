// Responsibility: Bootstraps Flutter, validates config, and runs the app.
// Supabase is initialized inside App after the first frame so the splash
// screen appears immediately on weak devices instead of blocking startup.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/env.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Prevent runtime font downloads from hanging the UI on poor/offline
      // networks (e.g. first open of editor screens using Caveat/Newsreader).
      GoogleFonts.config.allowRuntimeFetching = false;

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint('FlutterError: ${details.exceptionAsString()}');
        if (details.stack != null) {
          debugPrintStack(stackTrace: details.stack);
        }
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        debugPrint('Uncaught platform error: $error');
        debugPrintStack(stackTrace: stack);
        // Prevent unhandled async/platform errors (e.g. background auth/network
        // refresh failures when offline) from crashing the app.
        return true;
      };

      if (!Env.isConfigured) {
        runApp(MissingConfigApp(missingKeys: Env.missingKeys));
        return;
      }

      runApp(const ProviderScope(child: App()));
    },
    (Object error, StackTrace stack) {
      debugPrint('Uncaught zoned error: $error');
      debugPrintStack(stackTrace: stack);
    },
  );
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
