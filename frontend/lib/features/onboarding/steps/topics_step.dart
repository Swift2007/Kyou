// Responsibility: Collects topics the user writes about during onboarding (step 6 of 6).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

const List<String> _topics = <String>[
  'Work or study',
  'Relationships',
  'Family',
  'Goals',
  'Health and wellbeing',
  'Money',
  'Creativity',
  'Travel',
  'Faith and values',
  'Everyday life',
];

class TopicsStep extends ConsumerStatefulWidget {
  const TopicsStep({
    super.key,
    required this.onBack,
    required this.onSkip,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  @override
  ConsumerState<TopicsStep> createState() => _TopicsStepState();
}

class _TopicsStepState extends ConsumerState<TopicsStep> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...ref.read(onboardingViewModelProvider).data.topics};
  }

  void _save() {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final data = ref.read(onboardingViewModelProvider).data;
    vm.updateData(data.copyWith(topics: _selected));
  }

  void _toggle(String topic) {
    setState(() {
      if (_selected.contains(topic)) {
        _selected.remove(topic);
      } else {
        _selected.add(topic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 6,
      totalSteps: 6,
      onBack: () {
        _save();
        widget.onBack();
      },
      onSkip: () {
        _save();
        widget.onSkip();
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
          const OnboardingHeadline('What do you write about?'),
          const SizedBox(height: 6),
          const OnboardingSubtitle('Pick a few, or skip this.'),
          const SizedBox(height: 28),
          const WhyWeAskSticker(
            message: 'This helps tailor prompts and suggestions to what matters to you.',
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final topic in _topics)
                OnbChip(
                  label: topic,
                  selected: _selected.contains(topic),
                  onTap: () => _toggle(topic),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This only shapes prompts and suggestions. Nothing is shared.',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: OnbColors.muted,
              height: 14 / 9,
            ),
          ),
        ],
      ),
    );
  }
}
