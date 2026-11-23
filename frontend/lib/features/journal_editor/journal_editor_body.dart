// Responsibility: Multiline journal body editor — Newsreader 17 w400.
// Phase 3 MVP: editable wrapped body. Renders text wrapped around attachment
// exclusion rects, captures keyboard/IME via a hidden TextField, and draws a
// custom caret/selection mapped to wrapped layout coordinates.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'journal_editor_wrap_text.dart';

class JournalEditorBody extends StatefulWidget {
  final TextEditingController controller;
  final List<Rect> paperExclusionRects; // in paper coordinate space
  final GlobalKey? paperCoordinateKey; // key attached to paper coordinate space

  const JournalEditorBody({
    super.key,
    required this.controller,
    this.paperExclusionRects = const [],
    this.paperCoordinateKey,
  });

  @override
  State<JournalEditorBody> createState() => _JournalEditorBodyState();
}

class _JournalEditorBodyState extends State<JournalEditorBody> {
  final GlobalKey _bodyKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _hiddenFieldFocusNode = FocusNode();
  List<Rect> _localExclusions = const [];
  bool _showCaret = false;

  TextStyle get _baseStyle => TextStyle(fontFamily: 'Newsreader', fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
        height: 27 / 17,
      );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextOrSelectionChanged);
    _hiddenFieldFocusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeExclusions());
  }

  @override
  void didUpdateWidget(covariant JournalEditorBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextOrSelectionChanged);
      widget.controller.addListener(_onTextOrSelectionChanged);
    }
    if (oldWidget.paperExclusionRects != widget.paperExclusionRects ||
        oldWidget.paperCoordinateKey != widget.paperCoordinateKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeExclusions());
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextOrSelectionChanged);
    _hiddenFieldFocusNode.removeListener(_onFocusChange);
    _hiddenFieldFocusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextOrSelectionChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChange() {
    if (mounted) setState(() => _showCaret = _hiddenFieldFocusNode.hasFocus);
  }

  void _recomputeExclusions() {
    if (!mounted) return;
    final bodyCtx = _bodyKey.currentContext;
    final paperCtx = widget.paperCoordinateKey?.currentContext;
    if (bodyCtx == null || paperCtx == null) {
      if (_localExclusions.isNotEmpty) setState(() => _localExclusions = const []);
      return;
    }
    final bodyBox = bodyCtx.findRenderObject();
    final paperBox = paperCtx.findRenderObject();
    if (bodyBox is! RenderBox || paperBox is! RenderBox) return;
    if (!bodyBox.hasSize || !paperBox.hasSize) return;

    final bodyOriginInPaper = paperBox.globalToLocal(bodyBox.localToGlobal(Offset.zero));
    final local = <Rect>[];
    for (final r in widget.paperExclusionRects) {
      final shifted = r.shift(-bodyOriginInPaper);
      final bodyRect = Rect.fromLTWH(0, -80, bodyBox.size.width, bodyBox.size.height + 4000);
      if (shifted.overlaps(bodyRect)) local.add(shifted);
    }
    if (!_rectListEquals(local, _localExclusions)) {
      setState(() => _localExclusions = local);
    }
  }

  bool _rectListEquals(List<Rect> a, List<Rect> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _handleTapDown(TapDownDetails details, JournalWrapTextLayout layout) {
    _hiddenFieldFocusNode.requestFocus();
    final offset = wrapTextOffsetForPosition(
      layout: layout,
      style: _baseStyle,
      position: details.localPosition,
    );
    widget.controller.selection = TextSelection.collapsed(
      offset: offset.clamp(0, widget.controller.text.length),
    );
  }

  void _handleLongPressStart(LongPressStartDetails details, JournalWrapTextLayout layout) {
    _hiddenFieldFocusNode.requestFocus();
    final offset = wrapTextOffsetForPosition(
      layout: layout,
      style: _baseStyle,
      position: details.localPosition,
    ).clamp(0, widget.controller.text.length);
    widget.controller.selection = TextSelection.collapsed(offset: offset);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeExclusions());
    final base = _baseStyle;
    final text = widget.controller.text;
    final hasText = text.isNotEmpty;

    return ConstrainedBox(
      key: _bodyKey,
      constraints: const BoxConstraints(minHeight: 240),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0;
          final layout = JournalWrapTextLayouter.layout(
            text: hasText ? text : 'Dear me…',
            style: hasText ? base : base.copyWith(color: AppColors.muted.withValues(alpha: 0.6)),
            maxWidth: maxWidth,
            exclusions: _localExclusions,
          );
          final contentHeight = layout.height < 240 ? 240.0 : layout.height;
          final caretOffset = wrapCaretOffsetForTextOffset(
            layout: layout,
            style: base,
            textOffset: widget.controller.selection.isValid
                ? widget.controller.selection.extentOffset.clamp(0, text.length)
                : text.length,
          );
          final lineHeight = _lineHeight(base);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _handleTapDown(d, layout),
            onLongPressStart: (d) => _handleLongPressStart(d, layout),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: contentHeight,
                  width: maxWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (final line in layout.lines)
                        Positioned(
                          left: line.offset.dx,
                          top: line.offset.dy,
                          width: line.width,
                          child: Text(
                            line.text,
                            style: hasText ? base : base.copyWith(color: AppColors.muted.withValues(alpha: 0.6)),
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_showCaret && caretOffset != null)
                  Positioned(
                    left: caretOffset.dx,
                    top: caretOffset.dy + (lineHeight - (base.fontSize ?? 17) * 1.2) / 2,
                    child: IgnorePointer(
                      child: Container(
                        width: 2,
                        height: (base.fontSize ?? 17) * 1.2,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                // Hidden input field captures keyboard/IME while keeping UI wrapped.
                Positioned(
                  left: (caretOffset?.dx ?? 0).clamp(0.0, (maxWidth - 12).clamp(0.0, double.infinity)),
                  top: caretOffset?.dy ?? 0,
                  width: 12,
                  height: lineHeight,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _hiddenFieldFocusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    showCursor: false,
                    style: const TextStyle(color: Colors.transparent, fontSize: 17),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _lineHeight(TextStyle style) {
    final p = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: 'Mg', style: style),
      maxLines: 1,
    )..layout(maxWidth: double.infinity);
    final h = p.height;
    return h > 0 ? h : (style.fontSize ?? 16) * (style.height ?? 1.4);
  }
}
