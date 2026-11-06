// Responsibility: Renders the Home UI "Journal welcome" landing screen from the OpenPencil prototype.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/journal_kit.dart';

class JournalWelcomeScreen extends StatelessWidget {
  const JournalWelcomeScreen({
    super.key,
    required this.onStartJournaling,
    required this.onLogIn,
  });

  final VoidCallback onStartJournaling;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JournalColors.background,
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
                      const JournalMasthead(),
                      const SizedBox(height: 20),
                      const JournalAccentHeadline(
                        firstLine: 'MAKE ROOM\nFOR ',
                        accentText: 'YOU.',
                        note: 'YOUR MIND. UNEDITED.',
                      ),
                      const SizedBox(height: 8),
                      const _JournalCollage(),
                      const SizedBox(height: 18),
                      Text(
                        'A little space to spill your thoughts.\nNo right words. No perfect days.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: JournalColors.ink,
                          height: 24 / 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      JournalPrimaryButton(
                        label: 'Start journaling',
                        onPressed: onStartJournaling,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: onLogIn,
                          style: TextButton.styleFrom(
                            foregroundColor: JournalColors.muted,
                            minimumSize: const Size(44, 44),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Already have an account? Log in',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: JournalColors.muted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const JournalClosingNote(),
                      const SizedBox(height: 8),
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

class _JournalCollage extends StatelessWidget {
  const _JournalCollage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 16,
            top: 0,
            child: Transform.rotate(
              angle: -4 * 3.141592653589793 / 180,
              child: const _JournalPageCard(),
            ),
          ),
          const Positioned(
            left: 267,
            top: 101,
            child: _ExpressionBurst(),
          ),
          Positioned(
            left: 299,
            top: 117,
            child: Transform.rotate(
              angle: 9 * 3.141592653589793 / 180,
              child: Text(
                '!',
                style: GoogleFonts.anton(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color: JournalColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalPageCard extends StatelessWidget {
  const _JournalPageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 313,
      height: 158,
      decoration: BoxDecoration(
        color: JournalColors.page,
        border: Border.all(color: JournalColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: JournalColors.ink,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Writing rules
          for (final top in const [42.0, 70.0, 98.0, 126.0])
            Positioned(
              left: 0,
              top: top,
              right: 0,
              child: Container(height: 1, color: JournalColors.rule),
            ),
          // Margin rule
          Positioned(
            left: 34,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: JournalColors.accent),
          ),
          Positioned(
            left: 48,
            top: 13,
            child: Text(
              'A NOTE TO MYSELF',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: JournalColors.muted,
                letterSpacing: 1,
              ),
            ),
          ),
          Positioned(
            left: 49,
            top: 44,
            right: 17,
            child: Text(
              "I don't have to have it\nall figured out today.",
              style: GoogleFonts.caveat(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: JournalColors.ink,
                height: 28 / 32,
              ),
            ),
          ),
          Positioned(
            left: 49,
            top: 130,
            child: Text(
              'AND THAT\u2019S A START.',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: JournalColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpressionBurst extends StatelessWidget {
  const _ExpressionBurst();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(76, 76),
      painter: _BurstPainter(),
    );
  }
}

class _BurstPainter extends CustomPainter {
  static const _vertices = <Offset>[
    Offset(38, 0), Offset(45, 19), Offset(60, 5), Offset(59, 26),
    Offset(76, 26), Offset(63, 41), Offset(76, 55), Offset(55, 56),
    Offset(54, 76), Offset(39, 63), Offset(24, 76), Offset(24, 56),
    Offset(4, 59), Offset(16, 42), Offset(0, 29), Offset(21, 26),
    Offset(17, 7), Offset(33, 20),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(_vertices.first.dx, _vertices.first.dy);
    for (final v in _vertices.skip(1)) {
      path.lineTo(v.dx, v.dy);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = JournalColors.accent
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = JournalColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
