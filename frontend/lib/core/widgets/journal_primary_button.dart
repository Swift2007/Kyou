// Responsibility: Filled accent action button with ink border, hard offset shadow,
// and forward-arrow glyph — "Start journaling" / "Sign in" / "Create space". Extracted from journal_kit.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'journal_colors.dart';

/// Filled accent action button with ink border, hard offset shadow, and
/// forward-arrow glyph — "Start journaling" / "Sign in" / "Create space".
class JournalPrimaryButton extends StatelessWidget {
  const JournalPrimaryButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.55 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: JournalColors.accent,
          border: Border.all(color: JournalColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(
              color: JournalColors.ink,
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
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: JournalColors.ink,
                    ),
                  ),
                  const _ForwardArrow(),
                ],
              ),
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
      ..color = JournalColors.ink
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
