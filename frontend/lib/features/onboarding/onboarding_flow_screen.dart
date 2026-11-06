// Responsibility: Hosts the multi-step onboarding flow and renders the current step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_viewmodel.dart';
import 'steps/birthday_step.dart';
import 'steps/goals_step.dart';
import 'steps/location_step.dart';
import 'steps/name_step.dart';
import 'steps/rhythm_step.dart';
import 'steps/summary_step.dart';
import 'steps/topics_step.dart';
import 'steps/welcome_step.dart';

class OnboardingFlowScreen extends ConsumerWidget {
  const OnboardingFlowScreen({
    super.key,
    this.onFinished,
    this.onGetStarted,
    this.onSkipped,
    this.onSignIn,
  });

  /// Called when the user completes onboarding.
  final VoidCallback? onFinished;

  /// Legacy/router callback; treated as completing/exiting onboarding.
  final VoidCallback? onGetStarted;

  /// Called when the user skips/leaves onboarding.
  final VoidCallback? onSkipped;

  /// Legacy callback; treated as skipping/leaving onboarding.
  final VoidCallback? onSignIn;

  void _exit(VoidCallback? preferred) {
    (preferred ?? onFinished ?? onGetStarted)?.call();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);
    final vm = ref.read(onboardingViewModelProvider.notifier);

    Widget step;
    switch (state.stepIndex) {
      case 0:
        step = WelcomeStep(
          onGetStarted: vm.next,
          onSkipped: () => _exit(onSkipped ?? onSignIn ?? onFinished),
        );
        break;
      case 1:
        step = NameStep(
          onBack: vm.previous,
          onSkip: vm.skipStep,
          onContinue: vm.next,
        );
        break;
      case 2:
        step = BirthdayStep(
          onBack: vm.previous,
          onContinue: vm.next,
        );
        break;
      case 3:
        step = LocationStep(
          onBack: vm.previous,
          onSkip: vm.skipStep,
          onContinue: vm.next,
        );
        break;
      case 4:
        step = GoalsStep(
          onBack: vm.previous,
          onSkip: vm.skipStep,
          onContinue: vm.next,
        );
        break;
      case 5:
        step = RhythmStep(
          onBack: vm.previous,
          onSkip: vm.skipStep,
          onContinue: vm.next,
        );
        break;
      case 6:
        step = TopicsStep(
          onBack: vm.previous,
          onSkip: vm.skipStep,
          onContinue: vm.next,
        );
        break;
      case 7:
        step = SummaryStep(
          onBack: vm.previous,
          onEditStep: vm.goTo,
          onFinished: () => _exit(onFinished ?? onGetStarted),
        );
        break;
      default:
        step = WelcomeStep(
          onGetStarted: vm.next,
          onSkipped: () => _exit(onSkipped ?? onSignIn ?? onFinished),
        );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(
        key: ValueKey<int>(state.stepIndex),
        child: step,
      ),
    );
  }
}
