// Responsibility: Holds onboarding flow state and coordinates step progression.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_data.dart';

class OnboardingState {
  const OnboardingState({
    this.stepIndex = 0,
    this.data = const OnboardingData(),
    this.underageBlocked = false,
  });

  /// 0 welcome, 1 name, 2 birthday, 3 location, 4 goals, 5 rhythm, 6 topics, 7 finish.
  final int stepIndex;
  final OnboardingData data;
  final bool underageBlocked;

  OnboardingState copyWith({
    int? stepIndex,
    OnboardingData? data,
    bool? underageBlocked,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      data: data ?? this.data,
      underageBlocked: underageBlocked ?? this.underageBlocked,
    );
  }
}

class OnboardingViewModel extends Notifier<OnboardingState> {
  static const int stepCount = 8;

  @override
  OnboardingState build() => const OnboardingState();

  void next() {
    if (state.stepIndex < stepCount - 1) {
      state = state.copyWith(stepIndex: state.stepIndex + 1);
    }
  }

  void previous() {
    if (state.stepIndex > 0) {
      state = state.copyWith(stepIndex: state.stepIndex - 1, underageBlocked: false);
    }
  }

  void skipStep() => next();

  void goTo(int index) {
    if (index >= 0 && index < stepCount) {
      state = state.copyWith(stepIndex: index, underageBlocked: false);
    }
  }

  void updateData(OnboardingData data) {
    state = state.copyWith(data: data);
  }

  void setUnderageBlocked(bool value) {
    state = state.copyWith(underageBlocked: value);
  }
}

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
  OnboardingViewModel.new,
);
