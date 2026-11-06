// Responsibility: Renders the Home UI "Journal welcome" landing screen from the OpenPencil prototype.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _JournalWelcomeColors {
  const _JournalWelcomeColors._();

  static const background = Color(0xFFF3EEDF);
  static const ink = Color(0xFF191916);
  static const muted = Color(0xFF625F55);
  static const accent = Color(0xFFFF623C);
  static const page = Color(0xFFFFFDF5);
  static const rule = Color(0xFFC6C1B3);
}

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
      backgroundColor: _JournalWelcomeColors.background,
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
                      _Masthead(),
                      const SizedBox(height: 20),
                      _Headline(),
                      const SizedBox(height: 8),
                      const _JournalCollage(),
                      const SizedBox(height: 18),
                      Text(
                        'A little space to spill your thoughts.\nNo right words. No perfect days.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _JournalWelcomeColors.ink,
                          height: 24 / 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      _StartJournalingButton(onPressed: onStartJournaling),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: onLogIn,
                          style: TextButton.styleFrom(
                            foregroundColor: _JournalWelcomeColors.muted,
                            minimumSize: const Size(44, 44),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Already have an account? Log in',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _JournalWelcomeColors.muted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _ClosingNote(),
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

class _Masthead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _JournalWelcomeColors.ink, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KYOU',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: _JournalWelcomeColors.ink,
              letterSpacing: -1,
            ),
          ),
          Text(
            'WORKING TITLE.\nYOUR JOURNAL.',
            textAlign: TextAlign.right,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _JournalWelcomeColors.muted,
              height: 12 / 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.anton(
              fontSize: 76,
              fontWeight: FontWeight.w400,
              color: _JournalWelcomeColors.ink,
              height: 72 / 76,
              letterSpacing: -1.5,
            ),
            children: const [
              TextSpan(text: 'MAKE ROOM\nFOR '),
              TextSpan(
                text: 'YOU.',
                style: TextStyle(color: _JournalWelcomeColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Container(width: 28, height: 3, color: _JournalWelcomeColors.accent),
            const SizedBox(width: 10),
            Text(
              'YOUR MIND. UNEDITED.',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _JournalWelcomeColors.ink,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
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
                  color: _JournalWelcomeColors.ink,
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
        color: _JournalWelcomeColors.page,
        border: Border.all(color: _JournalWelcomeColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: _JournalWelcomeColors.ink,
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
              child: Container(height: 1, color: _JournalWelcomeColors.rule),
            ),
          // Margin rule
          Positioned(
            left: 34,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: _JournalWelcomeColors.accent),
          ),
          Positioned(
            left: 48,
            top: 13,
            child: Text(
              'A NOTE TO MYSELF',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: _JournalWelcomeColors.muted,
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
                color: _JournalWelcomeColors.ink,
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
                color: _JournalWelcomeColors.muted,
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
        ..color = _JournalWelcomeColors.accent
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _JournalWelcomeColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StartJournalingButton extends StatelessWidget {
  const _StartJournalingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: _JournalWelcomeColors.accent,
        border: Border.all(color: _JournalWelcomeColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: _JournalWelcomeColors.ink,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start journaling',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _JournalWelcomeColors.ink,
                  ),
                ),
                const _ForwardArrow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForwardArrow extends StatelessWidget {
  const _ForwardArrow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(25, 24),
      painter: _ForwardArrowPainter(),
    );
  }
}

class _ForwardArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _JournalWelcomeColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    final path = Path()
      ..moveTo(0, 12)
      ..lineTo(25, 12)
      ..moveTo(15, 0)
      ..lineTo(25, 12)
      ..lineTo(15, 24);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClosingNote extends StatelessWidget {
  const _ClosingNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: _JournalWelcomeColors.ink, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'LESS SCROLLING. MORE FEELING.',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _JournalWelcomeColors.muted,
              letterSpacing: 0.4,
            ),
          ),
          Text(
            'VOL. YOU',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _JournalWelcomeColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
