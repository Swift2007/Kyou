// Responsibility: Collects writing rhythm preferences during onboarding (step 5 of 6).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_data.dart';
import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

class RhythmStep extends ConsumerStatefulWidget {
  const RhythmStep({
    super.key,
    required this.onBack,
    required this.onSkip,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  @override
  ConsumerState<RhythmStep> createState() => _RhythmStepState();
}

class _RhythmStepState extends ConsumerState<RhythmStep> {
  WritingTime? _writingTime;
  WritingFrequency? _frequency;
  bool _remindGently = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 30);

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingViewModelProvider).data;
    _writingTime = data.writingTime;
    _frequency = data.frequency;
    _remindGently = data.remindGently;
    _reminderTime =
        _parseTime(data.reminderTime) ?? const TimeOfDay(hour: 20, minute: 30);
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    // Accept "8:30 PM" style.
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*([AaPp][Mm])$')
        .firstMatch(value.trim());
    if (match == null) return null;
    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final ampm = match.group(3)!.toUpperCase();
    if (ampm == 'PM' && hour != 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _save() {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final data = ref.read(onboardingViewModelProvider).data;
    vm.updateData(
      data.copyWith(
        writingTime: _writingTime,
        frequency: _frequency,
        remindGently: _remindGently,
        reminderTime: _remindGently ? _formatTime(_reminderTime) : null,
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: OnbColors.accent,
              onPrimary: OnbColors.onAccent,
              surface: OnbColors.page,
              onSurface: OnbColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 5,
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
          const OnboardingHeadline('Your writing rhythm', size: 34),
          const SizedBox(height: 6),
          const OnboardingSubtitle('When and how often feels right?'),
          const SizedBox(height: 28),
          const WhyWeAskSticker(
            message: 'We use this to suggest a gentle reminder time if you want one.',
          ),
          const SizedBox(height: 18),
          const OnbFieldLabel('When do you like to write?'),
          const SizedBox(height: 8),
          for (final value in WritingTime.values) ...[
            OnbOptionCard(
              label: OnboardingData.writingTimeLabel(value),
              selected: _writingTime == value,
              onTap: () => setState(() => _writingTime = value),
            ),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 10),
          const OnbFieldLabel('How often?'),
          const SizedBox(height: 8),
          OnbSegmentedFrequency(
            selected: _frequency,
            onChanged: (v) => setState(() => _frequency = v),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Remind me gently',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: OnbColors.ink,
                  ),
                ),
              ),
              OnbToggle(
                value: _remindGently,
                onChanged: (v) => setState(() => _remindGently = v),
              ),
            ],
          ),
          if (_remindGently) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: OnbColors.page,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OnbColors.ink, width: 2),
                  boxShadow: [hardShadow(x: 2, y: 2)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Reminder time',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: OnbColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(_reminderTime),
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: OnbColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
