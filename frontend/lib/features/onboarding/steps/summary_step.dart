// Responsibility: Shows onboarding summary and completes setup (step 7 / finish).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';
import '../widgets/onboarding_widgets.dart';

class SummaryStep extends ConsumerStatefulWidget {
  const SummaryStep({
    super.key,
    required this.onBack,
    required this.onEditStep,
    required this.onFinished,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onEditStep;
  final VoidCallback onFinished;

  @override
  ConsumerState<SummaryStep> createState() => _SummaryStepState();
}

class _SummaryStepState extends ConsumerState<SummaryStep> {
  bool _saving = false;
  bool _saveError = false;

  Future<void> _finish() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _saveError = false;
    });
    // Onboarding persistence is not yet wired to a backend; complete the flow.
    // Keep the error/retry UI available for fidelity with the prototype.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingViewModelProvider).data;
    final reminders = data.remindGently && (data.reminderTime?.trim().isNotEmpty ?? false)
        ? data.reminderTime!.trim()
        : 'Off';

    return Stack(
      children: [
        OnboardingScaffold(
          step: 6,
          totalSteps: 6,
          onBack: widget.onBack,
          // No Skip on finish.
          continueLabel: _saving ? 'Saving…' : 'Start writing',
          continueEnabled: !_saving,
          onContinue: _finish,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const OnboardingHeadline("You're all set"),
              const SizedBox(height: 2),
              const OnboardingSubtitle(
                "Here's what you told us. You can change any of it later.",
              ),
              const SizedBox(height: 10),
              const WhyWeAskSticker(
                message: 'You can update or delete this information in your profile any time.',
              ),
              const SizedBox(height: 16),
              _SummaryCard(
                rows: [
                  _Row('Name', data.nickname.trim().isEmpty ? 'Not set' : data.nickname.trim(), 1),
                  _Row('Birthday', data.birthdaySummary, 2),
                  _Row('Birth year only', data.birthYearOnly ? 'On' : 'Off', 2),
                  _Row('Location', data.locationSummary, 3),
                  _Row('Time zone', data.timeZone.trim().isEmpty ? 'Not set' : data.timeZone.trim(), 3),
                  _Row('Why you journal', data.goalsSummary, 4),
                  _Row('Rhythm', data.rhythmSummary, 5),
                  _Row('Reminders', reminders, 5),
                  _Row('Topics', data.topicsSummary, 6),
                ],
                onEdit: widget.onEditStep,
              ),
              const SizedBox(height: 14),
              const _PrivacyNoteSticker(),
              // Leave room so toast/error doesn't cover content awkwardly.
              if (_saveError) const SizedBox(height: 72),
            ],
          ),
        ),
        if (_saveError)
          Positioned(
            left: 24,
            right: 24,
            bottom: 96,
            child: SafeArea(
              top: false,
              child: _NetworkErrorToast(
                onRetry: () {
                  setState(() => _saveError = false);
                  _finish();
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _Row {
  const _Row(this.label, this.value, this.editStep);
  final String label;
  final String value;
  final int editStep;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.rows, required this.onEdit});
  final List<_Row> rows;
  final ValueChanged<int> onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OnbColors.page,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OnbColors.ink, width: 2),
        boxShadow: [hardShadow(x: 4, y: 4)],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _SummaryRow(row: rows[i], onEdit: () => onEdit(rows[i].editStep)),
            if (i < rows.length - 1)
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: const Color(0x14191916),
              ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.row, required this.onEdit});
  final _Row row;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: OnbColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  row.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: OnbColors.ink,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEdit,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OnbColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyNoteSticker extends StatelessWidget {
  const _PrivacyNoteSticker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: OnbColors.privacy,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OnbColors.ink, width: 2),
        boxShadow: [hardShadow(x: 2, y: 2)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 14,
            height: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 1,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 10,
                    decoration: BoxDecoration(
                      color: OnbColors.ink,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 0,
                  child: Container(
                    width: 6,
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: OnbColors.ink, width: 1.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your entries are private. You can change or delete this information in Profile any time.',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: OnbColors.ink,
                height: 15 / 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkErrorToast extends StatelessWidget {
  const _NetworkErrorToast({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: OnbColors.page,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OnbColors.error, width: 2),
        boxShadow: [hardShadow(x: 4, y: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: OnbColors.error,
              shape: BoxShape.circle,
            ),
            child: Text(
              '!',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: OnbColors.onAccent,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Couldn't save. Check your connection.",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: OnbColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                color: OnbColors.accent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OnbColors.ink, width: 2),
                boxShadow: [hardShadow(x: 2, y: 2)],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRetry,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Center(
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: OnbColors.onAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
