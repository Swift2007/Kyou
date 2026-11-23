// Responsibility: Read-only text wrapping prototype for journal editor body.
// Wraps text around exclusion rectangles (attachment bounds) using TextPainter.
// Phase 2 prototype — not yet editable; Phase 3 will add editing/caret/IME.
import 'package:material_ui/material_ui.dart';

class WrapTextLine {
  final String text;
  final Offset offset; // top-left of this line segment
  final double width;
  final int start; // start index in source text
  final int end; // end index in source text (exclusive)

  const WrapTextLine({
    required this.text,
    required this.offset,
    required this.width,
    required this.start,
    required this.end,
  });
}

class JournalWrapTextLayout {
  final List<WrapTextLine> lines;
  final double height;

  const JournalWrapTextLayout({required this.lines, required this.height});
}

class JournalWrapTextLayouter {
  static JournalWrapTextLayout layout({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required List<Rect> exclusions,
    double lineGapExtra = 0,
  }) {
    if (maxWidth <= 0) {
      return const JournalWrapTextLayout(lines: [], height: 0);
    }

    final normalized = text.replaceAll('\r\n', '\n');
    final paragraphs = normalized.split('\n');
    final painter = TextPainter(textDirection: TextDirection.ltr, maxLines: 1);

    final lineHeight = _measureLineHeight(style, painter);
    final lines = <WrapTextLine>[];
    double y = 0;
    const maxY = 20000.0; // safety cap

    int paraStart = 0;
    for (int p = 0; p < paragraphs.length; p++) {
      final para = paragraphs[p];
      if (para.isEmpty) {
        // Empty paragraph: represent as empty line marker.
        y += lineHeight;
        paraStart += 1; // just the \n
        continue;
      }

      int index = 0; // index within para
      while (index < para.length && y < maxY) {
        final segments = _freeSegmentsForBand(
          y: y,
          height: lineHeight,
          maxWidth: maxWidth,
          exclusions: exclusions,
        );
        if (segments.isEmpty) {
          y += lineHeight;
          continue;
        }

        bool placedAny = false;
        for (final seg in segments) {
          if (index >= para.length) break;
          final remaining = para.substring(index);
          final fit = _fitText(remaining, style, seg.width, painter);
          if (fit.count <= 0) continue;

          final chunk = remaining.substring(0, fit.count);
          final absStart = paraStart + index;
          final absEnd = absStart + fit.count;
          lines.add(
            WrapTextLine(
              text: chunk,
              offset: Offset(seg.left, y),
              width: seg.width,
              start: absStart,
              end: absEnd,
            ),
          );
          index += fit.count;
          placedAny = true;
          if (index < para.length) {
            // Trim leading spaces on the next wrapped segment.
            while (index < para.length && para[index] == ' ') {
              index++;
            }
          }
          // Move to next band after placing one segment for this line step.
          y += lineHeight;
          break;
        }

        if (!placedAny) {
          y += lineHeight;
        }
      }
      paraStart += para.length + 1; // +1 for \n (or past end on last)
    }

    final height = lines.isEmpty ? lineHeight : (lines.last.offset.dy + lineHeight);
    return JournalWrapTextLayout(lines: lines, height: height);
  }

  static double _measureLineHeight(TextStyle style, TextPainter painter) {
    painter.text = TextSpan(text: 'Mg', style: style);
    painter.layout(maxWidth: double.infinity);
    final h = painter.height;
    painter.text = null;
    return h > 0 ? h : (style.fontSize ?? 16) * (style.height ?? 1.4);
  }

  static _FittedText _fitText(
    String text,
    TextStyle style,
    double maxWidth,
    TextPainter painter,
  ) {
    if (maxWidth <= 1) return const _FittedText(0);
    painter.text = TextSpan(text: text, style: style);
    painter.layout(maxWidth: maxWidth);

    final pos = painter.getPositionForOffset(
      Offset(maxWidth, painter.height / 2),
    );
    int end = pos.offset.clamp(0, text.length);

    // Prefer breaking at whitespace if we're not at end.
    if (end < text.length) {
      final lastSpace = text.substring(0, end).lastIndexOf(' ');
      if (lastSpace > 0) {
        end = lastSpace + 1; // keep space at end of line
      }
    }
    if (end <= 0) {
      // Force at least one char to avoid infinite loops on very narrow segments.
      end = 1;
    }
    return _FittedText(end);
  }

  static List<_HorizontalSegment> _freeSegmentsForBand({
    required double y,
    required double height,
    required double maxWidth,
    required List<Rect> exclusions,
  }) {
    final bandTop = y;
    final bandBottom = y + height;
    final overlapping = <Rect>[];
    for (final r in exclusions) {
      final rr = r.inflate(4); // small breathing room around attachments
      if (rr.bottom <= bandTop || rr.top >= bandBottom) continue;
      overlapping.add(
        Rect.fromLTRB(
          rr.left.clamp(0.0, maxWidth),
          rr.top,
          rr.right.clamp(0.0, maxWidth),
          rr.bottom,
        ),
      );
    }
    overlapping.sort((a, b) => a.left.compareTo(b.left));

    // Merge overlapping horizontal blockers.
    final merged = <Rect>[];
    for (final r in overlapping) {
      if (merged.isEmpty) {
        merged.add(r);
      } else {
        final last = merged.last;
        if (r.left <= last.right + 1) {
          merged[merged.length - 1] = Rect.fromLTRB(
            last.left,
            last.top,
            r.right > last.right ? r.right : last.right,
            last.bottom,
          );
        } else {
          merged.add(r);
        }
      }
    }

    final segments = <_HorizontalSegment>[];
    double cursor = 0;
    for (final r in merged) {
      if (r.left - cursor >= 24) {
        segments.add(_HorizontalSegment(cursor, r.left));
      }
      if (r.right > cursor) cursor = r.right;
    }
    if (maxWidth - cursor >= 24) {
      segments.add(_HorizontalSegment(cursor, maxWidth));
    }

    // Keep left-to-right for reading flow.
    return segments;
  }
}

class _HorizontalSegment {
  final double left;
  final double right;
  const _HorizontalSegment(this.left, this.right);
  double get width => right - left;
}

class _FittedText {
  final int count;
  const _FittedText(this.count);
}

class JournalWrapText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Rect> exclusions;
  final double? minHeight;

  const JournalWrapText({
    super.key,
    required this.text,
    required this.style,
    this.exclusions = const [],
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final layout = JournalWrapTextLayouter.layout(
          text: text.isEmpty ? ' ' : text,
          style: style,
          maxWidth: maxWidth,
          exclusions: exclusions,
        );
        final height = (minHeight != null && minHeight! > layout.height)
            ? minHeight!
            : layout.height;
        return SizedBox(
          height: height,
          width: maxWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < layout.lines.length; i++)
                Positioned(
                  left: layout.lines[i].offset.dx,
                  top: layout.lines[i].offset.dy,
                  width: layout.lines[i].width,
                  child: Text(
                    layout.lines[i].text,
                    style: style,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Offset? wrapCaretOffsetForTextOffset({
  required JournalWrapTextLayout layout,
  required TextStyle style,
  required int textOffset,
}) {
  if (layout.lines.isEmpty) return Offset.zero;
  final painter = TextPainter(textDirection: TextDirection.ltr, maxLines: 1);
  for (final line in layout.lines) {
    if (textOffset < line.start || textOffset > line.end) continue;
    final localIndex = (textOffset - line.start).clamp(0, line.text.length);
    painter.text = TextSpan(text: line.text, style: style);
    painter.layout(maxWidth: line.width);
    final boxes = painter.getBoxesForSelection(
      TextSelection(baseOffset: localIndex, extentOffset: localIndex),
    );
    double dx = 0;
    if (boxes.isNotEmpty) {
      dx = boxes.first.left;
    } else if (localIndex > 0) {
      // End of line
      painter.text = TextSpan(text: line.text.substring(0, localIndex), style: style);
      painter.layout(maxWidth: line.width);
      dx = painter.width;
    }
    return Offset(line.offset.dx + dx, line.offset.dy);
  }
  // Fallback: after last line
  final last = layout.lines.last;
  painter.text = TextSpan(text: last.text, style: style);
  painter.layout(maxWidth: last.width);
  return Offset(last.offset.dx + painter.width, last.offset.dy);
}

int wrapTextOffsetForPosition({
  required JournalWrapTextLayout layout,
  required TextStyle style,
  required Offset position,
}) {
  if (layout.lines.isEmpty) return 0;
  final painter = TextPainter(textDirection: TextDirection.ltr, maxLines: 1);
  // Find closest line by y
  WrapTextLine? target;
  double bestDy = double.infinity;
  final lineHeight = _wrapLineHeight(style);
  for (final line in layout.lines) {
    final midY = line.offset.dy + lineHeight / 2;
    final dy = (position.dy - midY).abs();
    if (dy < bestDy) {
      bestDy = dy;
      target = line;
    }
  }
  target ??= layout.lines.last;
  final localDx = (position.dx - target.offset.dx).clamp(0.0, target.width);
  painter.text = TextSpan(text: target.text, style: style);
  painter.layout(maxWidth: target.width);
  final pos = painter.getPositionForOffset(Offset(localDx, lineHeight / 2));
  final local = pos.offset.clamp(0, target.text.length);
  return (target.start + local).clamp(0, 1 << 30);
}

double _wrapLineHeight(TextStyle style) {
  final p = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(text: 'Mg', style: style),
    maxLines: 1,
  )..layout(maxWidth: double.infinity);
  final h = p.height;
  return h > 0 ? h : (style.fontSize ?? 16) * (style.height ?? 1.4);
}
