// Responsibility: Shared visual primitives for the onboarding flow, matching the
// OpenPencil "onBoarding" page prototypes.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_data.dart';

class OnbColors {
  OnbColors._();

  static const background = Color(0xFFF3EBDD);
  static const topBar = Color(0xFFFFFDF5);
  static const card = Color(0xFFFFF8EC);
  static const page = Color(0xFFFFFDF5);
  static const ink = Color(0xFF191916);
  static const muted = Color(0xFF625F55);
  static const accent = Color(0xFFFF623C);
  static const onAccent = Color(0xFFFFF5F5);
  static const disabledFill = Color(0xFFE5DDD0);
  static const line = Color(0xFFD0C8BA);
  static const why = Color(0xFFF5E27A);
  static const error = Color(0xFFC43D2E);
  static const privacy = Color(0xFF7ED4B0);
  static const dim = Color(0x38191916); // ~22% ink
}

BoxShadow hardShadow({double x = 4, double y = 4}) =>
    BoxShadow(color: OnbColors.ink, offset: Offset(x, y), blurRadius: 0);

/// Pinned onboarding chrome: cream background + top bar (back/progress)
/// with scrollable body and a pinned bottom continue button.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.step, // 1-6 (progress steps); 0 hides progress context
    required this.totalSteps,
    required this.child,
    this.onBack,
    this.continueLabel = 'Continue',
    this.onContinue,
    this.continueEnabled = true,
    this.showProgress = true,
    this.bottom,
  });

  final int step;
  final int totalSteps;
  final Widget child;
  final VoidCallback? onBack;
  final String continueLabel;
  final VoidCallback? onContinue;
  final bool continueEnabled;
  final bool showProgress;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnbColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (showProgress)
              OnboardingTopBar(
                step: step,
                totalSteps: totalSteps,
                onBack: onBack,
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: child,
              ),
            ),
            if (onContinue != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: OnboardingContinueButton(
                  label: continueLabel,
                  enabled: continueEnabled,
                  onPressed: onContinue,
                ),
              ),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}

class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    super.key,
    required this.step,
    required this.totalSteps,
    this.onBack,
  });

  final int step;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      width: double.infinity,
      decoration: BoxDecoration(
        color: OnbColors.topBar,
        border: Border.all(color: OnbColors.ink, width: 2),
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          if (onBack != null)
            Positioned(
              left: 8,
              top: 46,
              width: 44,
              height: 44,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBack,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8),
                    child: Text(
                      '\u2190',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: OnbColors.ink,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 24,
            top: 42,
            child: Text(
              'Step $step of $totalSteps',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: OnbColors.muted,
                height: 1,
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 60,
            right: 24,
            child: Row(
              children: [
                for (var i = 1; i <= totalSteps; i++) ...[
                  Expanded(
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: i <= step ? OnbColors.accent : OnbColors.page,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: OnbColors.ink, width: 2),
                        boxShadow: [
                          hardShadow(
                            x: i <= step ? 2 : 4,
                            y: i <= step ? 2 : 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < totalSteps) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingHeadline extends StatelessWidget {
  const OnboardingHeadline(this.text, {super.key, this.size = 36});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.caveat(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: OnbColors.ink,
        height: 1.1,
      ),
    );
  }
}

class OnboardingSubtitle extends StatelessWidget {
  const OnboardingSubtitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.newsreader(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: OnbColors.muted,
        height: 22 / 15,
      ),
    );
  }
}

class WhyWeAskSticker extends StatefulWidget {
  const WhyWeAskSticker({super.key, required this.message});
  final String message;

  @override
  State<WhyWeAskSticker> createState() => _WhyWeAskStickerState();
}

class _WhyWeAskStickerState extends State<WhyWeAskSticker> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final expandedWidth = MediaQuery.sizeOf(context).width - 48;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: _expanded ? expandedWidth : 118,
        constraints: BoxConstraints(minHeight: _expanded ? 56 : 30),
        padding: EdgeInsets.fromLTRB(
          10,
          _expanded ? 7 : 6,
          10,
          _expanded ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: OnbColors.why,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: OnbColors.ink, width: 2),
          boxShadow: [hardShadow(x: 2, y: 2)],
        ),
        child: _expanded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _label(),
                  const SizedBox(height: 6),
                  Text(
                    widget.message,
                    style: GoogleFonts.newsreader(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: OnbColors.ink,
                      height: 18 / 13,
                    ),
                  ),
                ],
              )
            : _label(),
      ),
    );
  }

  Widget _label() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '?',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: OnbColors.ink,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Why we ask',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: OnbColors.ink,
          ),
        ),
      ],
    );
  }
}

class OnboardingContinueButton extends StatelessWidget {
  const OnboardingContinueButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final active = enabled && onPressed != null;
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: active ? OnbColors.accent : OnbColors.disabledFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OnbColors.ink, width: 2),
          boxShadow: [hardShadow()],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: active ? onPressed : null,
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: active ? OnbColors.onAccent : OnbColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnbFieldBox extends StatelessWidget {
  OnbFieldBox({
    super.key,
    this.height = 52,
    this.error = false,
    BoxShadow? shadow,
    this.child,
  }) : shadow = shadow ?? hardShadow(x: 3, y: 3);

  final double height;
  final bool error;
  final BoxShadow shadow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: OnbColors.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: error ? OnbColors.error : OnbColors.ink,
          width: error ? 3 : 2,
        ),
        boxShadow: error ? [hardShadow(x: 2, y: 2)] : [shadow],
      ),
      child: child,
    );
  }
}

class OnbFieldLabel extends StatelessWidget {
  const OnbFieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: OnbColors.muted,
      ),
    );
  }
}

class OnbChip extends StatelessWidget {
  const OnbChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? OnbColors.accent : OnbColors.page,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: OnbColors.ink, width: 2),
          boxShadow: [hardShadow(x: selected ? 3 : 2, y: selected ? 3 : 2)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                // Constant weight prevents Wrap reflow when toggling selection.
                fontWeight: FontWeight.w600,
                color: selected ? OnbColors.onAccent : OnbColors.ink,
              ),
            ),
            // Reserve space so selecting/deselecting never changes chip width.
            const SizedBox(width: 6),
            Opacity(
              opacity: selected ? 1 : 0,
              child: Text(
                '\u2713',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? OnbColors.onAccent : OnbColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnbToggle extends StatelessWidget {
  const OnbToggle({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? OnbColors.accent : OnbColors.disabledFill,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: OnbColors.ink, width: 2),
          boxShadow: [hardShadow(x: 2, y: 2)],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 120),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: OnbColors.page,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: OnbColors.ink, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class OnbErrorBadge extends StatelessWidget {
  const OnbErrorBadge(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: OnbColors.page,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: OnbColors.error, width: 2),
        boxShadow: [hardShadow(x: 2, y: 2)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: OnbColors.error,
              borderRadius: BorderRadius.circular(3),
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
          const SizedBox(width: 6),
          Text(
            message,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: OnbColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

/// Option card used in step 5 (rhythm time-of-day). Radio-style.
class OnbOptionCard extends StatelessWidget {
  const OnbOptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? OnbColors.card : OnbColors.page,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OnbColors.ink, width: selected ? 3 : 2),
          boxShadow: [hardShadow(x: selected ? 4 : 2, y: selected ? 4 : 2)],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? OnbColors.accent : OnbColors.page,
                shape: BoxShape.circle,
                border: Border.all(color: OnbColors.ink, width: 2),
              ),
              child: selected
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: OnbColors.onAccent,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: OnbColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Frequency segmented control (step 5).
class OnbSegmentedFrequency extends StatelessWidget {
  const OnbSegmentedFrequency({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WritingFrequency? selected;
  final ValueChanged<WritingFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: OnbColors.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OnbColors.ink, width: 2),
        boxShadow: [hardShadow(x: 2, y: 2)],
      ),
      child: Row(
        children: [
          for (final value in WritingFrequency.values)
            Expanded(
              child: _Seg(
                label: OnboardingData.frequencyLabel(value),
                selected: selected == value,
                onTap: () => onChanged(value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? OnbColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: selected ? Border.all(color: OnbColors.ink, width: 2) : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? OnbColors.onAccent : OnbColors.ink,
          ),
        ),
      ),
    );
  }
}
