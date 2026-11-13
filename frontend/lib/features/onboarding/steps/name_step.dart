// Responsibility: Collects the user's nickname during onboarding (step 1 of 6).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

class NameStep extends ConsumerStatefulWidget {
  const NameStep({super.key, required this.onBack, required this.onContinue});

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  ConsumerState<NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<NameStep> {
  late final TextEditingController _controller;
  static const int _max = 40;

  @override
  void initState() {
    super.initState();
    final name = ref.read(onboardingViewModelProvider).data.nickname;
    _controller = TextEditingController(text: name);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final data = ref.read(onboardingViewModelProvider).data;
    vm.updateData(data.copyWith(nickname: _controller.text.trim()));
  }

  void _continue() {
    _save();
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final canContinue = text.trim().isNotEmpty;

    return OnboardingScaffold(
      step: 1,
      totalSteps: 6,
      onBack: () {
        _save();
        widget.onBack();
      },
      continueLabel: 'Continue',
      continueEnabled: canContinue,
      onContinue: _continue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const OnboardingHeadline('What should we call you?'),
          const SizedBox(height: 6),
          const OnboardingSubtitle('Just a nickname is fine.'),
          const SizedBox(height: 28),
          const WhyWeAskSticker(
            message: 'So your journal can greet you by name.',
          ),
          const SizedBox(height: 22),
          const OnbFieldLabel('Nickname'),
          const SizedBox(height: 6),
          OnbFieldBox(
            child: TextField(
              controller: _controller,
              maxLength: _max,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => canContinue ? _continue() : null,
              style: GoogleFonts.caveat(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: OnbColors.ink,
                height: 24 / 22,
              ),
              decoration: InputDecoration(
                counterText: '',
                isCollapsed: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: '',
                hintStyle: GoogleFonts.caveat(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: OnbColors.muted,
                  height: 24 / 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${text.characters.length} / $_max',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: OnbColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
