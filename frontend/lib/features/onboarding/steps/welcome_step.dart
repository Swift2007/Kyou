// Responsibility: Renders the welcoming screen (Onboarding / 0) from the OpenPencil prototype.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_viewmodel.dart';

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

class WelcomeStep extends ConsumerWidget {
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

  void _handleGetStarted(OnboardingViewModel viewModel) {
    if (onGetStarted != null) {
      onGetStarted!.call();
      return;
    }
    viewModel.next();
    onFinished?.call();
  }

  void _handleSkip(OnboardingViewModel viewModel) {
    if (onSkipped != null) {
      onSkipped!.call();
      return;
    }
    // Default: treat skip as finishing/leaving the welcome step.
    viewModel.next();
    onFinished?.call();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: _WelcomeColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      const _IllustrationCard(),
                      const SizedBox(height: 30),
                      Text(
                        "Let's set up your journal",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.caveat(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: _WelcomeColors.ink,
                          height: 1.1,
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
                      const SizedBox(height: 24),
                      _PrimaryActionButton(
                        label: 'Get started',
                        onPressed: () => _handleGetStarted(viewModel),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: TextButton(
                          onPressed: () => _handleSkip(viewModel),
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard();

  @override
  Widget build(BuildContext context) {
    // Matches prototype: 342x360 card containing notebook+pen illustration.
    return Center(
      child: Container(
        width: 342,
        height: 360,
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
                child: Stack(
                  children: const [
                    Positioned(left: 12, top: 22, child: _NotebookLine(width: 90)),
                    Positioned(left: 12, top: 42, child: _NotebookLine(width: 90)),
                    Positioned(left: 12, top: 62, child: _NotebookLine(width: 90)),
                    Positioned(left: 12, top: 82, child: _NotebookLine(width: 60)),
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
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
  });

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
