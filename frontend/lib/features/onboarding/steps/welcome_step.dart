// Responsibility: Renders the welcoming screen (Onboarding / 0) from the OpenPencil prototype.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Prototype palette (Onboarding / 0 Welcome).
class _WelcomeColors {
  const _WelcomeColors._();

  static const background = Color(0xFFF3EBDD);
  static const card = Color(0xFFFFF8EC);
  static const notebook = Color(0xFFFFFDF5);
  static const ink = Color(0xFF191916);
  static const muted = Color(0xFF625F55);
  static const accent = Color(0xFFFF623C);
  static const line = Color(0xFFD0C8BA);
  static const penTip = Color(0xFFF5E27A);
  static const buttonText = Color(0xFFFFF5F5);
}

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({
    super.key,
    this.onFinished,
    this.onGetStarted,
    this.onSkipped,
  });

  /// Legacy callback; used as fallback for [onGetStarted] when provided alone.
  final VoidCallback? onFinished;

  /// Called when the user taps "Get started".
  final VoidCallback? onGetStarted;

  /// Called when the user taps "Skip for now".
  final VoidCallback? onSkipped;

  void _handleGetStarted() {
    (onGetStarted ?? onFinished)?.call();
  }

  void _handleSkip() {
    (onSkipped ?? onFinished)?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _WelcomeColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Flexible(
                flex: 4,
                fit: FlexFit.loose,
                child: Center(child: _IllustrationCard()),
              ),
              const SizedBox(height: 16),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Let's set up your journal",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caveat(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: _WelcomeColors.ink,
                    height: 50 / 40,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Takes about a minute. You can skip most of it.',
                textAlign: TextAlign.center,
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _WelcomeColors.muted,
                  height: 23 / 16,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              _PrimaryActionButton(
                label: 'Get started',
                onPressed: _handleGetStarted,
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: _handleSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: _WelcomeColors.muted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: const Size(44, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Skip for now',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _WelcomeColors.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard();

  static const double _designWidth = 342;
  static const double _designHeight = 360;

  @override
  Widget build(BuildContext context) {
    // Matches prototype: 342x360 card containing notebook+pen illustration.
    // Scales down to fit narrower phones so the layout stays unscrollable.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: SizedBox(
        width: _designWidth,
        height: _designHeight,
        child: Container(
          decoration: BoxDecoration(
            color: _WelcomeColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _WelcomeColors.ink, width: 2),
            boxShadow: const [
              BoxShadow(
                color: _WelcomeColors.ink,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Notebook: frame (130,150) => card-relative (106,90), 120x150.
              Positioned(
                left: 106,
                top: 90,
                child: Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    color: _WelcomeColors.notebook,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _WelcomeColors.ink, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: _WelcomeColors.ink,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 15,
                        top: 25,
                        child: _NotebookLine(width: 90),
                      ),
                      Positioned(
                        left: 15,
                        top: 45,
                        child: _NotebookLine(width: 90),
                      ),
                      Positioned(
                        left: 15,
                        top: 65,
                        child: _NotebookLine(width: 90),
                      ),
                      Positioned(
                        left: 15,
                        top: 85,
                        child: _NotebookLine(width: 60),
                      ),
                    ],
                  ),
                ),
              ),
              // Pen: frame (230,190) => card-relative (206,130), 14x100.
              Positioned(
                left: 206,
                top: 130,
                child: Container(
                  width: 14,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _WelcomeColors.accent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _WelcomeColors.ink, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: _WelcomeColors.ink,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              // Pen tip: frame (233,280) => card-relative (209,220), 8x16.
              Positioned(
                left: 209,
                top: 220,
                child: Container(
                  width: 8,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _WelcomeColors.penTip,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: _WelcomeColors.ink, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotebookLine extends StatelessWidget {
  const _NotebookLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: _WelcomeColors.line,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _WelcomeColors.accent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _WelcomeColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: _WelcomeColors.ink,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _WelcomeColors.buttonText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
