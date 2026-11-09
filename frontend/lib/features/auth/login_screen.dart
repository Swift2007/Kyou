// Responsibility: Renders the Home UI "Sign in" screen and submits to the AuthViewModel.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/validators.dart';
import '../../core/widgets/journal_kit.dart';
import 'auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authViewModelProvider);
        final error = authState is AsyncError
            ? authState.error.toString()
            : null;
        final isLoading = authState is AsyncLoading;

        return Scaffold(
          backgroundColor: JournalColors.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Unscrollable by user; sized to fit the screen.
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const JournalMasthead(),
                          const SizedBox(height: 6),
                          const JournalAccentHeadline(
                            firstLine: 'YOUR SPACE\nIS ',
                            accentText: 'WAITING.',
                            note: 'NO PAPERS REQUIRED.',
                          ),
                          const SizedBox(height: 8),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                JournalTextField(
                                  label: 'EMAIL',
                                  hint: 'hi@untitled.space',
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  validator: validateEmail,
                                  onSaved: (value) =>
                                      _email = (value ?? '').trim(),
                                ),
                                const SizedBox(height: 8),
                                JournalTextField(
                                  label: 'PASSWORD',
                                  hint: '\u2022' * 10,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  validator: validatePassword,
                                  onSaved: (value) => _password = value ?? '',
                                ),
                              ],
                            ),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              error,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.red.shade700,
                                height: 1.2,
                              ),
                            ),
                          ],
                          const Spacer(),
                          const SizedBox(height: 8),
                          JournalPrimaryButton(
                            label: 'Sign in',
                            onPressed: isLoading
                                ? null
                                : () => _submit(context, ref),
                          ),
                          const SizedBox(height: 12),
                          JournalGoogleButton(
                            onPressed: isLoading
                                ? null
                                : () => ref
                                      .read(authViewModelProvider.notifier)
                                      .signInWithGoogle(),
                          ),
                          const SizedBox(height: 4),
                          JournalSecondaryRow(
                            question: 'New here?',
                            action: 'Start a journal',
                            onAction: isLoading
                                ? null
                                : () => context.go('/signup'),
                          ),
                          const SizedBox(height: 2),
                          const JournalClosingNote(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await ref.read(authViewModelProvider.notifier).signIn(_email, _password);
    // On success the router's refreshListenable redirect moves to /entries.
  }
}
