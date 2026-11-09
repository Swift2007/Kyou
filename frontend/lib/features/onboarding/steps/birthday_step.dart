// Responsibility: Collects and validates the user's birthday during onboarding (step 2 of 6).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_data.dart';
import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

const List<String> _months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class BirthdayStep extends ConsumerStatefulWidget {
  const BirthdayStep({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  ConsumerState<BirthdayStep> createState() => _BirthdayStepState();
}

class _BirthdayStepState extends ConsumerState<BirthdayStep> {
  late final TextEditingController _day;
  late final TextEditingController _year;
  String _month = '';
  bool _birthYearOnly = false;
  bool _showInvalid = false;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingViewModelProvider).data;
    _day = TextEditingController(text: data.birthDay);
    _year = TextEditingController(text: data.birthYear);
    _month = data.birthMonth;
    _birthYearOnly = data.birthYearOnly;
    for (final c in [_day, _year]) {
      c.addListener(_onChanged);
    }
  }

  void _onChanged() {
    if (_showInvalid) setState(() => _showInvalid = false);
    if (ref.read(onboardingViewModelProvider).underageBlocked) {
      ref.read(onboardingViewModelProvider.notifier).setUnderageBlocked(false);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _day.dispose();
    _year.dispose();
    super.dispose();
  }

  OnboardingData _currentData() {
    final base = ref.read(onboardingViewModelProvider).data;
    return base.copyWith(
      birthDay: _day.text.trim(),
      birthMonth: _month.trim(),
      birthYear: _year.text.trim(),
      birthYearOnly: _birthYearOnly,
    );
  }

  void _save() {
    ref.read(onboardingViewModelProvider.notifier).updateData(_currentData());
  }

  bool get _complete =>
      _day.text.trim().isNotEmpty &&
      _month.trim().isNotEmpty &&
      _year.text.trim().isNotEmpty;

  void _continue() {
    final data = _currentData();
    final vm = ref.read(onboardingViewModelProvider.notifier);
    vm.updateData(data);
    if (!data.hasBirthday || data.birthdayDate == null) {
      setState(() => _showInvalid = true);
      return;
    }
    if (data.isUnderMinAge) {
      vm.setUnderageBlocked(true);
      return;
    }
    vm.setUnderageBlocked(false);
    widget.onContinue();
  }

  Future<void> _pickMonth() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: OnbColors.page,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: OnbColors.ink, width: 2),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: OnbColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final m in _months)
                ListTile(
                  dense: true,
                  title: Text(
                    m,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: m == _month
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: OnbColors.ink,
                    ),
                  ),
                  trailing: m == _month
                      ? const Icon(
                          Icons.check,
                          color: OnbColors.accent,
                          size: 18,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(m),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _month = picked;
        _showInvalid = false;
      });
      if (ref.read(onboardingViewModelProvider).underageBlocked) {
        ref
            .read(onboardingViewModelProvider.notifier)
            .setUnderageBlocked(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocked = ref.watch(onboardingViewModelProvider).underageBlocked;
    if (blocked) {
      return _UnderageBlocked(
        onBack: () {
          ref
              .read(onboardingViewModelProvider.notifier)
              .setUnderageBlocked(false);
        },
      );
    }

    final error = _showInvalid;
    final canContinue = _complete && !error;

    return OnboardingScaffold(
      step: 2,
      totalSteps: 6,
      onBack: () {
        _save();
        widget.onBack();
      },
      // No Skip on step 2 per prototype.
      continueLabel: 'Continue',
      continueEnabled: canContinue,
      onContinue: _continue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const OnboardingHeadline("When's your birthday?"),
          const SizedBox(height: 6),
          const OnboardingSubtitle('We use this to confirm your age.'),
          const SizedBox(height: 28),
          const OnbFieldLabel('DAY / MONTH / YEAR'),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 94,
                child: _DateBox(
                  controller: _day,
                  hint: 'Day',
                  error: error,
                  keyboardType: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _pickMonth,
                  child: OnbFieldBox(
                    error: error,
                    shadow: hardShadow(x: 2, y: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _month.isEmpty ? 'Month' : _month,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: _month.isEmpty
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                              color: _month.isEmpty
                                  ? OnbColors.muted
                                  : OnbColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 102,
                child: _DateBox(
                  controller: _year,
                  hint: 'Year',
                  error: error,
                  keyboardType: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
          if (error) ...[
            const SizedBox(height: 10),
            const OnbErrorBadge("That date doesn't look right"),
          ],
          SizedBox(height: error ? 18 : 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Only use my birth year in the app',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: OnbColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  OnbToggle(
                    value: _birthYearOnly,
                    onChanged: (v) {
                      setState(() => _birthYearOnly = v);
                      _save();
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _birthYearOnly ? 'ON' : 'OFF',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: OnbColors.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const WhyWeAskSticker(
            message:
                'We use your birthday to confirm you meet the age requirement.',
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.controller,
    required this.hint,
    required this.error,
    this.keyboardType,
    this.formatters,
  });

  final TextEditingController controller;
  final String hint;
  final bool error;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    return OnbFieldBox(
      error: error,
      shadow: hardShadow(x: 2, y: 2),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
          color: OnbColors.ink,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: OnbColors.muted,
          ),
        ),
      ),
    );
  }
}

class _UnderageBlocked extends StatelessWidget {
  const _UnderageBlocked({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: OnbColors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 342,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                  decoration: BoxDecoration(
                    color: OnbColors.page,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: OnbColors.ink, width: 3),
                    boxShadow: [hardShadow(x: 6, y: 6)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: OnbColors.card,
                          shape: BoxShape.circle,
                          border: Border.all(color: OnbColors.ink, width: 2),
                          boxShadow: [hardShadow(x: 3, y: 3)],
                        ),
                        child: Text(
                          '!',
                          style: GoogleFonts.inter(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: OnbColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Not available yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.caveat(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: OnbColors.ink,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "This journal app isn't available for people under MIN_AGE (placeholder: ${OnboardingData.minAge}).",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.newsreader(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: OnbColors.muted,
                          height: 24 / 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'If you entered the wrong birthday, you can go back and fix it.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: OnbColors.muted,
                          height: 19 / 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: OnbColors.page,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: OnbColors.ink, width: 2),
                            boxShadow: [hardShadow(x: 3, y: 3)],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onBack,
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(
                                  'Go back',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: OnbColors.ink,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Kind blocking screen — no way to continue (MIN_AGE=${OnboardingData.minAge}).',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: OnbColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
