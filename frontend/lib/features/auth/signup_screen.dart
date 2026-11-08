// Responsibility: Renders the Home UI "Sign up" screen and submits to the AuthViewModel.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/validators.dart';
import '../../core/widgets/journal_kit.dart';
import 'auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authViewModelProvider);
        final error = authState is AsyncError ? authState.error.toString() : null;
        final isLoading = authState is AsyncLoading;

        return Scaffold(
          backgroundColor: JournalColors.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const JournalMasthead(),
                          const SizedBox(height: 20),
                          const JournalAccentHeadline(
                            firstLine: 'START YOUR\n',
                            accentText: 'VOLUME ONE.',
                            note: 'PENS DOWN. JUST A NAME.',
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                JournalTextField(
                                  label: 'EMAIL',
                                  hint: 'hello@untitled.space',
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  validator: validateEmail,
                                  onSaved: (value) => _email = (value ?? '').trim(),
                                ),
                                const SizedBox(height: 20),
                                JournalTextField(
                                  label: 'PASSWORD',
                                  hint: '\u2022' * 10,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  validator: validatePassword,
                                  onSaved: (value) => _password = value ?? '',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'JUST YOU AND THE PAGE.',
                                  style: GoogleFonts.ibmPlexMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: JournalColors.muted,
                                    letterSpacing: 1,
                                    height: 12 / 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              error,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.red.shade700,
                                height: 1.3,
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          Text(
                            'An account only holds the door.\nThe pages hold you.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: JournalColors.ink,
                              height: 24 / 16,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 20),
                          JournalPrimaryButton(
                            label: 'Create space',
                            onPressed: isLoading
                                ? null
                                : () => _submit(context, ref),
                          ),
                          const SizedBox(height: 14),
                          JournalGoogleButton(
                            onPressed: isLoading
                                ? null
                                : () => ref
                                    .read(authViewModelProvider.notifier)
                                    .signInWithGoogle(),
                          ),
                          const SizedBox(height: 14),
                          JournalSecondaryRow(
                            question: 'Already keeping a journal?',
                            action: 'Sign in',
                            onAction:
                                isLoading ? null : () => context.go('/login'),
                          ),
                          const SizedBox(height: 12),
                          const JournalClosingNote(),
                          const SizedBox(height: 8),
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
    await ref.read(authViewModelProvider.notifier).signUp(_email, _password);
    if (!context.mounted) return;
    final state = ref.read(authViewModelProvider);
    if (!state.hasError) {
      context.go('/onboarding');
    }
  }
}
