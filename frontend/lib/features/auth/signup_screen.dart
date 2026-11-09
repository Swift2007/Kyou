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
                            firstLine: 'START YOUR\n',
                            accentText: 'VOLUME ONE.',
                            note: 'PENS DOWN. JUST A NAME.',
                          ),
                          const SizedBox(height: 8),
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
                            label: 'Create space',
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
                            question: 'Already keeping a journal?',
                            action: 'Sign in',
                            onAction: isLoading
                                ? null
                                : () => context.go('/login'),
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
    await ref.read(authViewModelProvider.notifier).signUp(_email, _password);
    // Navigation is handled by the router based on the session and onboarding
    // metadata. If email confirmation is required there is no session, so the
    // user stays here; guide them clearly.
    if (!context.mounted) return;
    final state = ref.read(authViewModelProvider);
    if (!state.hasError && !state.isLoading) {
      final session = state.asData?.value;
      if (session == null) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: JournalColors.page,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: JournalColors.ink, width: 2),
              borderRadius: BorderRadius.circular(2),
            ),
            title: Text(
              'Confirm your email',
              style: GoogleFonts.anton(
                fontSize: 24,
                color: JournalColors.ink,
                fontWeight: FontWeight.w400,
              ),
            ),
            content: Text(
              'We sent a confirmation link to $_email. Open it to confirm your account, then sign in.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: JournalColors.ink,
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(
                    color: JournalColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (context.mounted) context.go('/login');
                },
                child: Text(
                  'Go to sign in',
                  style: GoogleFonts.inter(
                    color: JournalColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
