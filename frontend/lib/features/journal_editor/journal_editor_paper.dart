// Responsibility: Responsive paper/writing surface container for the editor.
// OpenPencil-aligned: surface fill, 2px inside stroke, r14, hard shadow (6,6),
// top binder-tab "pinned" detail (straddling top edge), and ruled lines/margin
// filling the whole paper.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorPaper extends StatelessWidget {
  final Widget child;
  final double minHeight;

  const JournalEditorPaper({
    super.key,
    required this.child,
    this.minHeight = 520,
  });

  static const double _tabOverlap = 3.0; // half of 6px tab height, to center on edge

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: _tabOverlap),
          constraints: BoxConstraints(minHeight: minHeight),
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
        ),
        // Binder tabs layered above so they straddle the paper's top edge.
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 6,
          child: IgnorePointer(
            child: CustomPaint(painter: _BinderTabsPainter()),
          ),
        ),
      ],
    );
  }
}

class _BinderTabsPainter extends CustomPainter {
  const _BinderTabsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // OpenPencil-exact binder tabs centered on the paper's top edge.
    // 18x6, r2, 1px ink stroke, surface fill, spaced 30px apart.
    const tabWidth = 18.0;
    const tabHeight = 6.0;
    const tabRadius = Radius.circular(2);
    const spacing = 30.0;
    const sideInset = 12.0;

    final fillPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double x = sideInset; x + tabWidth <= size.width - sideInset + 0.5; x += spacing) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, tabWidth, tabHeight),
        tabRadius,
      );
      canvas.drawRRect(rect, fillPaint);
      canvas.drawRRect(rect, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaperLinesPainter extends CustomPainter {
  const _PaperLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _paintRuledLines(canvas, size);
    _paintMarginGuide(canvas, size);
  }

  void _paintRuledLines(Canvas canvas, Size size) {
    // Subtle ruled lines filling the whole paper (OpenPencil: ~6% ink, 28px spacing).
    final linePaint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    // Inset lines within the paper so they sit in the writing area.
    const leftInset = 24.0;
    const rightInset = 16.0;
    const bottomInset = 24.0;
    // Start below header/title/mood rhythm and continue to bottom to fill the sheet.
    const firstLineY = 150.0;
    const lineGap = 28.0;

    final lineLeft = leftInset;
    final lineRight = size.width - rightInset;
    if (lineRight <= lineLeft) return;

    for (double y = firstLineY; y <= size.height - bottomInset; y += lineGap) {
      canvas.drawLine(
        Offset(lineLeft, y),
        Offset(lineRight, y),
        linePaint,
      );
    }
  }

  void _paintMarginGuide(Canvas canvas, Size size) {
    // OpenPencil-like left margin guide (reddish tint, subtle).
    final marginPaint = Paint()
      ..color = const Color(0xFFD98B8B).withValues(alpha: 0.22)
      ..strokeWidth = 1;

    const marginX = 44.0;
    const top = 120.0;
    const bottomInset = 24.0;
    final bottom = size.height - bottomInset;
    if (bottom <= top) return;

    canvas.drawLine(
      Offset(marginX, top),
      Offset(marginX, bottom),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
