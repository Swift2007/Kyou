// Responsibility: Collects the user's journaling goals during onboarding (step 4 of 6).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

const List<String> _goals = <String>[
  'Clear my mind',
  'Track my growth',
  'Remember moments',
  'Gratitude',
  'Work through feelings',
  'Set and review goals',
  'Be more creative',
  'Just curious',
];

class GoalsStep extends ConsumerStatefulWidget {
  const GoalsStep({super.key, required this.onBack, required this.onContinue});

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  ConsumerState<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends ConsumerState<GoalsStep> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...ref.read(onboardingViewModelProvider).data.goals};
  }

  void _save() {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final data = ref.read(onboardingViewModelProvider).data;
    vm.updateData(data.copyWith(goals: _selected));
  }

  void _toggle(String goal) {
    setState(() {
      if (_selected.contains(goal)) {
        _selected.remove(goal);
      } else {
        _selected.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 4,
      totalSteps: 6,
      onBack: () {
        _save();
        widget.onBack();
      },
      continueLabel: 'Continue',
      continueEnabled: true,
      onContinue: () {
        _save();
        widget.onContinue();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const OnboardingHeadline('Why do you journal?', size: 34),
          const SizedBox(height: 6),
          const OnboardingSubtitle('Pick what fits. This is optional.'),
          const SizedBox(height: 28),
          const WhyWeAskSticker(
            message: 'Helps us show you the features that matter most first.',
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final goal in _goals)
                OnbChip(
                  label: goal,
                  selected: _selected.contains(goal),
                  onTap: () => _toggle(goal),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Pick as many as you like',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: OnbColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
