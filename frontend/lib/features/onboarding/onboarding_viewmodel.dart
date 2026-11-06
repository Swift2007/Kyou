// Responsibility: Holds onboarding flow state and coordinates step progression.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  const OnboardingState({this.stepIndex = 0});

  final int stepIndex;

  OnboardingState copyWith({int? stepIndex}) =>
      OnboardingState(stepIndex: stepIndex ?? this.stepIndex);
}

class OnboardingViewModel extends Notifier<OnboardingState> {
  static const int stepCount = 1;

  @override
  OnboardingState build() => const OnboardingState();

  void next() {
    if (state.stepIndex < stepCount - 1) {
      state = state.copyWith(stepIndex: state.stepIndex + 1);
    }
  }

  void previous() {
    if (state.stepIndex > 0) {
      state = state.copyWith(stepIndex: state.stepIndex - 1);
    }
  }

  void goTo(int index) {
    if (index >= 0 && index < stepCount) {
      state = state.copyWith(stepIndex: index);
    }
  }
}

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
  OnboardingViewModel.new,
);

