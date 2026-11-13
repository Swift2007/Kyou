// Responsibility: Renders the Sign up screen matching the OpenPencil
// Home UI prototype exactly (frame 0:966, 402x874).
// No status bar per user instruction.
//
// Structure from OpenPencil:
// - Masthead: "WORKING TITLE.\nYOUR JOURNAL."
// - Headline: "START YOUR\nVOLUME ONE." + accent rule + "PENS DOWN. JUST A NAME."
// - Sign up form: EMAIL field, PASSWORD field, "JUST YOU AND THE PAGE."
// - Welcome message: "An account only holds the door.\nThe pages hold you."
// - Welcome actions: "Create space" + forward arrow, "Continue with Google", "Already keeping a journal? / Sign in"
// - Closing note: "LESS SCROLLING. MORE FEELING." / "VOL. YOU"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../core/widgets/journal_kit.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Masthead
            const JournalMasthead(),
            const SizedBox(height: 24),
            // Headline section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'START YOUR\nVOLUME ONE.',
                    style: AppTextStyles.headline(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(width: 24, height: 3, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text(
                        'PENS DOWN. JUST A NAME.',
                        style: AppTextStyles.caption(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Sign up form
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _SignUpForm(),
            ),
            const SizedBox(height: 24),
            // Welcome message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'An account only holds the door.\nThe pages hold you.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  height: 22 / 15,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _SignUpActions(),
            ),
            const Spacer(),
            // Closing note
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: JournalClosingNote(),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email field
        JournalTextField(
          label: 'EMAIL',
          hint: 'hello@untitled.space',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),
        // Password field
        JournalTextField(
          label: 'PASSWORD',
          hint: '••••••••••',
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16),
        // Disclaimer
        Text(
          'JUST YOU AND THE PAGE.',
          style: AppTextStyles.caption(),
        ),
      ],
    );
  }
}

class _SignUpActions extends StatelessWidget {
  const _SignUpActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JournalPrimaryButton(
          label: 'Create space',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 18, height: 18),
                    SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 17 / 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already keeping a journal?',
              style: AppTextStyles.bodyMuted(),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => context.go('/login'),
              child: Text(
                'Sign in',
                style: AppTextStyles.label().copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
