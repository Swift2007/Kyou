// Responsibility: Responsive paper/writing surface container for the editor.
// OpenPencil-aligned: surface fill, 2px stroke, r14, hard shadow (6,6),
// with subtle ruled paper lines and margin guide.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorPaper extends StatelessWidget {
  final Widget child;

  const JournalEditorPaper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 520),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _PaperLinesPainter()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 20, 96),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperLinesPainter extends CustomPainter {
  const _PaperLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.rule.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    final marginPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    const leftPadding = 24.0;
    const rightPadding = 20.0;
    const topStart = 64.0;
    const lineGap = 28.0;
    const marginX = 18.0;

    // Horizontal ruled lines
    for (double y = topStart; y < size.height - 24; y += lineGap) {
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        linePaint,
      );
    }

    // Left margin guide
    canvas.drawLine(
      const Offset(marginX, 24),
      Offset(marginX, size.height - 24),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
