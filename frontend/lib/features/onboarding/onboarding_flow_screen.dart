// Responsibility: Hosts the multi-step onboarding flow and renders the current step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_viewmodel.dart';
import 'steps/welcome_step.dart';

class OnboardingFlowScreen extends ConsumerWidget {
  const OnboardingFlowScreen({
    super.key,
    this.onFinished,
    this.onGetStarted,
    this.onSkipped,
    this.onSignIn,
  });

  /// Called when the user completes onboarding (placeholder for future steps).
  final VoidCallback? onFinished;

  /// Called when the user starts setup from the welcome screen.
  final VoidCallback? onGetStarted;

  /// Called when the user skips setup from the welcome screen.
  final VoidCallback? onSkipped;

  /// Called when the user chooses to sign in instead of starting onboarding.
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    final Widget step;
    switch (state.stepIndex) {
      case 0:
        step = WelcomeStep(
          onGetStarted: () {
            viewModel.next();
            (onGetStarted ?? onFinished)?.call();
          },
          onSkipped: () {
            (onSkipped ?? onSignIn ?? onFinished)?.call();
          },
        );
        break;
      default:
        step = WelcomeStep(
          onGetStarted: () {
            viewModel.next();
            (onGetStarted ?? onFinished)?.call();
          },
          onSkipped: () {
            (onSkipped ?? onSignIn ?? onFinished)?.call();
          },
        );
    }

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: KeyedSubtree(
            key: ValueKey<int>(state.stepIndex),
            child: step,
          ),
        ),
      ),
    );
  }
}

