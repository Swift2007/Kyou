// Responsibility: Responsive paper/writing surface container for the editor.
// OpenPencil-aligned: surface fill, 2px inside stroke, r14, hard shadow (6,6),
// top binder-tab "pinned" detail, ruled lines/margin filling the whole paper,
// and a free-form attachment layer (Phase 4: drag/place anywhere on the sheet).
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'journal_editor_attachment_block.dart';

class JournalEditorPaper extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final List<JournalAttachment> attachments;
  final void Function(
    JournalAttachment attachment,
    Offset delta,
    Size paperSize,
  )?
  onMoveAttachment;
  final void Function(JournalAttachment attachment, Size paperSize)?
  onAttachmentDragEnd;
  final void Function(JournalAttachment attachment)? onLiftAttachment;
  final void Function(String id)? onRemoveAttachment;

  const JournalEditorPaper({
    super.key,
    required this.child,
    this.minHeight = 520,
    this.attachments = const <JournalAttachment>[],
    this.onMoveAttachment,
    this.onAttachmentDragEnd,
    this.onLiftAttachment,
    this.onRemoveAttachment,
  });

  static const double _tabOverlap =
      3.0; // half of 6px tab height, to center on edge

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
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _PaperLinesPainter()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 28, 20, 48),
                  child: child,
                ),
                if (attachments.isNotEmpty)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final paperSize = constraints.biggest;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (final attachment in attachments)
                              Positioned(
                                left: attachment.dx,
                                top: attachment.dy,
                                child: FreeformAttachment(
                                  key: ValueKey<String>(attachment.id),
                                  attachment: attachment,
                                  onRemove: onRemoveAttachment == null
                                      ? null
                                      : () =>
                                            onRemoveAttachment!(attachment.id),
                                  onDragUpdate: onMoveAttachment == null
                                      ? null
                                      : (delta) => onMoveAttachment!(
                                          attachment,
                                          delta,
                                          paperSize,
                                        ),
                                  onDragEnd: onAttachmentDragEnd == null
                                      ? null
                                      : () => onAttachmentDragEnd!(
                                          attachment,
                                          paperSize,
                                        ),
                                  onLift: onLiftAttachment == null
                                      ? null
                                      : () => onLiftAttachment!(attachment),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
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

    for (
      double x = sideInset;
      x + tabWidth <= size.width - sideInset + 0.5;
      x += spacing
    ) {
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
  @override
  void paint(Canvas canvas, Size size) {
    _paintRuledLines(canvas, size);
    _paintMarginGuide(canvas, size);
  }

  void _paintRuledLines(Canvas canvas, Size size) {
    // Full-page ruled lines across the whole paper (notebook feel).
    final linePaint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    const leftInset = 56.0; // start after margin guide
    const rightInset = 16.0;
    const lineGap = 28.0;
    const firstLineY = 56.0; // start below the title line (remove line above "Give today a name")

    final lineLeft = leftInset;
    final lineRight = size.width - rightInset;
    if (lineRight <= lineLeft) return;

    for (double y = firstLineY; y <= size.height - 4; y += lineGap) {
      canvas.drawLine(Offset(lineLeft, y), Offset(lineRight, y), linePaint);
    }
  }

  void _paintMarginGuide(Canvas canvas, Size size) {
    final marginPaint = Paint()
      ..color = const Color(0xFFD98B8B).withValues(alpha: 0.24)
      ..strokeWidth = 1;

    const marginX = 44.0;
    const top = 12.0;
    final bottom = size.height - 4;
    if (bottom <= top) return;

    canvas.drawLine(Offset(marginX, top), Offset(marginX, bottom), marginPaint);
  }

  @override
  bool shouldRepaint(covariant _PaperLinesPainter oldDelegate) => true;
}
