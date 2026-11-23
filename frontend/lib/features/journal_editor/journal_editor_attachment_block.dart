// Responsibility: Attachment models and visuals (polaroid/chip style).
// Phase 4 refinement: photos & audio use move/snap placement; long-press (~0.6s)
// to lift/move again. Photos get washi tape on snap (audio no tape). Fluid local drag.
import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

enum JournalAttachmentKind { voice, image, file }

class JournalAttachment {
  final String id;
  final JournalAttachmentKind kind;
  final String title;
  final String subtitle;
  double dx;
  double dy;
  bool isPlaced; // snapped/confirmed in place (journal placement flow)

  JournalAttachment({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.dx = 0,
    this.dy = 0,
    this.isPlaced = true,
  });

  bool get usesJournalPlacement =>
      kind == JournalAttachmentKind.image || kind == JournalAttachmentKind.voice;

  bool get showsTape => kind == JournalAttachmentKind.image;

  Size get visualSize {
    switch (kind) {
      case JournalAttachmentKind.image:
        return const Size(88, 104);
      case JournalAttachmentKind.voice:
        return const Size(148, 36);
      case JournalAttachmentKind.file:
        return const Size(140, 36);
    }
  }

  // Total footprint including wrapper padding/close affordance used in layout.
  Size get footprintSize => Size(visualSize.width + 12, visualSize.height + 12);
}

class FreeformAttachment extends StatefulWidget {
  final JournalAttachment attachment;
  final Size paperSize;
  final VoidCallback? onRemove;
  final void Function(Offset finalPosition)? onDragCommit; // commit on release
  final VoidCallback? onLift; // long-hold to lift a placed journal item

  const FreeformAttachment({
    super.key,
    required this.attachment,
    required this.paperSize,
    this.onRemove,
    this.onDragCommit,
    this.onLift,
  });

  @override
  State<FreeformAttachment> createState() => _FreeformAttachmentState();
}

class _FreeformAttachmentState extends State<FreeformAttachment> {
  Timer? _holdTimer;
  Offset _localDragOffset = Offset.zero;
  bool _isDragging = false;

  bool get _usesJournalPlacement => widget.attachment.usesJournalPlacement;
  bool get _isPlacedJournalItem =>
      _usesJournalPlacement && widget.attachment.isPlaced;
  bool get _canDrag => widget.onDragCommit != null && !_isPlacedJournalItem;

  void _startHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      widget.onLift?.call();
    });
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  Offset _clampedLocalOffset(Offset proposedLocal) {
    final size = widget.attachment.footprintSize;
    final maxX = (widget.paperSize.width - size.width).clamp(
      0.0,
      double.infinity,
    );
    final maxY = (widget.paperSize.height - size.height).clamp(
      0.0,
      double.infinity,
    );
    final targetX = (widget.attachment.dx + proposedLocal.dx).clamp(0.0, maxX);
    final targetY = (widget.attachment.dy + proposedLocal.dy).clamp(0.0, maxY);
    return Offset(
      targetX - widget.attachment.dx,
      targetY - widget.attachment.dy,
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (!_canDrag) return;
    _cancelHoldTimer();
    setState(() {
      _isDragging = true;
      _localDragOffset = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_canDrag || !_isDragging) return;
    setState(() {
      _localDragOffset = _clampedLocalOffset(_localDragOffset + details.delta);
    });
  }

  void _finishDrag() {
    if (!_isDragging) return;
    final finalPosition = Offset(
      widget.attachment.dx + _localDragOffset.dx,
      widget.attachment.dy + _localDragOffset.dy,
    );
    setState(() {
      _isDragging = false;
      _localDragOffset = Offset.zero;
    });
    widget.onDragCommit?.call(finalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_canDrag) return;
    _finishDrag();
  }

  void _onPanCancel() {
    if (!_canDrag) return;
    _finishDrag();
  }

  @override
  void didUpdateWidget(covariant FreeformAttachment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachment.id != widget.attachment.id ||
        oldWidget.attachment.isPlaced != widget.attachment.isPlaced) {
      _cancelHoldTimer();
      _localDragOffset = Offset.zero;
      _isDragging = false;
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachment = widget.attachment;

    final visual = _AttachmentVisual(
      attachment: attachment,
      showTape: attachment.showsTape && attachment.isPlaced,
    );

    Widget child;

    if (_isPlacedJournalItem) {
      child = Listener(
        onPointerDown: (_) => _startHoldTimer(),
        onPointerUp: (_) => _cancelHoldTimer(),
        onPointerCancel: (_) => _cancelHoldTimer(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: visual,
        ),
      );
    } else {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _canDrag ? _onPanStart : null,
        onPanUpdate: _canDrag ? _onPanUpdate : null,
        onPanEnd: _canDrag ? _onPanEnd : null,
        onPanCancel: _canDrag ? _onPanCancel : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Opacity(
                opacity: _usesJournalPlacement && !attachment.isPlaced
                    ? 0.96
                    : 1.0,
                child: visual,
              ),
            ),
            if (widget.onRemove != null)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: widget.onRemove,
                  behavior: HitTestBehavior.opaque,
                  child: const _RemoveButton(),
                ),
              ),
          ],
        ),
      );
    }

    return Transform.translate(offset: _localDragOffset, child: child);
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.ink, width: 1.5),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(1, 1), blurRadius: 0),
        ],
      ),
      child: const Icon(Icons.close, size: 12, color: AppColors.ink),
    );
  }
}

class _AttachmentVisual extends StatelessWidget {
  final JournalAttachment attachment;
  final bool showTape;

  const _AttachmentVisual({required this.attachment, required this.showTape});

  @override
  Widget build(BuildContext context) {
    switch (attachment.kind) {
      case JournalAttachmentKind.image:
        return _PhotoPolaroid(showTape: showTape);
      case JournalAttachmentKind.voice:
        return _VoiceNoteChip(
          label: attachment.title.isNotEmpty ? attachment.title : 'voice note',
          duration: attachment.subtitle,
        );
      case JournalAttachmentKind.file:
        return _FileChip(label: attachment.title, subtitle: attachment.subtitle);
    }
  }
}

class _PhotoPolaroid extends StatelessWidget {
  final bool showTape;
  const _PhotoPolaroid({required this.showTape});

  @override
  Widget build(BuildContext context) {
    final polaroid = Container(
      width: 88,
      height: 104,
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD8D2C4),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: AppColors.ink, width: 1),
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 22, color: AppColors.muted),
        ),
      ),
    );

    if (!showTape) return polaroid;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        polaroid,
        Positioned(
          top: -4,
          left: 18,
          child: Transform.rotate(
            angle: -0.12,
            child: const _TapeStrip(width: 46, height: 14),
          ),
        ),
      ],
    );
  }
}

class _TapeStrip extends StatelessWidget {
  final double width;
  final double height;
  const _TapeStrip({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF6E7A8).withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFD8C97A), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }
}

class _VoiceNoteChip extends StatelessWidget {
  final String label;
  final String duration;

  const _VoiceNoteChip({required this.label, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          const Text(
            '♪',
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 4),
          const Expanded(child: _WaveformBars()),
          const SizedBox(width: 6),
          Text(
            duration.isNotEmpty ? duration : '0:00',
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformBars extends StatelessWidget {
  const _WaveformBars();

  @override
  Widget build(BuildContext context) {
    const heights = <double>[8, 12, 7, 14, 10, 13, 6, 11, 9, 7, 12, 8];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < heights.length; i++) ...[
          Container(
            width: 2,
            height: heights[i],
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: i.isEven ? 0.85 : 0.55),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          if (i != heights.length - 1) const SizedBox(width: 2),
        ],
      ],
    );
  }
}

class _FileChip extends StatelessWidget {
  final String label;
  final String subtitle;

  const _FileChip({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 16,
            color: AppColors.ink,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label.isNotEmpty ? label : 'file',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
