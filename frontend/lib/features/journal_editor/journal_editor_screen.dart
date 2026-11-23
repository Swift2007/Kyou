// Responsibility: Journal Editor screen (OpenPencil Journal Editor page 0:56).
// Phase 1 foundation + Phase 2 rich content + Phase 3 speed dial interactions
// + Phase 4 sheets/cards and reorderable attachment blocks.
// No status bar. Responsive, modular layout.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'journal_editor_app_bar.dart';
import 'journal_editor_attachment_block.dart';
import 'journal_editor_attachment_sheet.dart';
import 'journal_editor_body.dart';
import 'journal_editor_mood.dart';
import 'journal_editor_mood_sheet.dart';
import 'journal_editor_paper.dart';
import 'journal_editor_prediction_block.dart';
import 'journal_editor_reply_card.dart';
import 'journal_editor_speed_dial.dart';
import 'journal_editor_tags.dart';
import 'journal_editor_title.dart';
import 'journal_editor_tool_toggle.dart';

class _ReplyData {
  final String sourceLabel;
  final String quote;

  const _ReplyData({required this.sourceLabel, required this.quote});
}

class _PredictionData {
  final String text;
  final String dueLabel;
  String confidence;

  _PredictionData({
    required this.text,
    required this.dueLabel,
    required this.confidence,
  });
}

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _speedDialOpen = false;
  bool _saved = false;
  JournalMoodLevel? _selectedMood;
  int _moodIntensity = 3;
  final List<String> _tags = <String>[];
  final List<JournalAttachment> _attachments = <JournalAttachment>[];
  _ReplyData? _reply;
  _PredictionData? _prediction;
  int _attachmentSeed = 0;

  static const List<String> _confidenceOptions = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onContentChanged);
    _bodyController.addListener(_onContentChanged);
  }

  void _onContentChanged() => setState(() {});

  @override
  void dispose() {
    _titleController
      ..removeListener(_onContentChanged)
      ..dispose();
    _bodyController
      ..removeListener(_onContentChanged)
      ..dispose();
    super.dispose();
  }

  void _closeEditor() => Navigator.of(context).maybePop();

  void _markDone() {
    FocusScope.of(context).unfocus();
    setState(() => _saved = true);
  }

  void _toggleSpeedDial() => setState(() => _speedDialOpen = !_speedDialOpen);

  void _closeSpeedDial() => setState(() => _speedDialOpen = false);

  int get _extrasCount {
    var count = 0;
    if (_selectedMood != null) count++;
    if (_tags.isNotEmpty) count++;
    if (_attachments.isNotEmpty) count++;
    if (_prediction != null) count++;
    if (_reply != null) count++;
    return count;
  }

  int get _attachmentCount => _attachments.length;

  void _showHint(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _addTag() async {
    final controller = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.ink, width: 2),
          ),
          title: Text(
            'Add tag',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. work'),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    final cleaned = tag?.trim().replaceAll(RegExp(r'^#+'), '');
    if (cleaned == null || cleaned.isEmpty) return;
    if (_tags.any((t) => t.toLowerCase() == cleaned.toLowerCase())) return;
    setState(() => _tags.add(cleaned));
  }

  void _removeTag(String tag) => setState(() => _tags.remove(tag));

  void _addAttachment(
    JournalAttachmentKind kind,
    String title,
    String subtitle,
  ) {
    setState(() {
      _attachmentSeed++;
      // Stagger defaults in free areas of the paper (handwritten/scrapbook placement).
      final baseX = 24.0 + ((_attachmentSeed - 1) % 3) * 40.0;
      final baseY =
          360.0 +
          ((_attachmentSeed - 1) % 2) * 120.0 +
          ((_attachmentSeed - 1) ~/ 3) * 24.0;
      final usesJournalPlacement =
          kind == JournalAttachmentKind.image ||
          kind == JournalAttachmentKind.voice;
      _attachments.add(
        JournalAttachment(
          id: '${kind.name}-$_attachmentSeed',
          kind: kind,
          title: title,
          subtitle: subtitle,
          dx: baseX,
          dy: baseY,
          // Photos & voice notes (1b): start in move mode, snap on release.
          // Tape appears on snap for photos only. Files stay freely placeable.
          isPlaced: !usesJournalPlacement,
        ),
      );
    });
  }

  void _removeAttachment(String id) {
    setState(() => _attachments.removeWhere((a) => a.id == id));
  }

  void _moveAttachment(
    JournalAttachment attachment,
    Offset delta,
    Size paperSize,
  ) {
    setState(() {
      final size = attachment.footprintSize;
      final maxX = (paperSize.width - size.width).clamp(0.0, double.infinity);
      final maxY = (paperSize.height - size.height).clamp(0.0, double.infinity);
      attachment.dx = (attachment.dx + delta.dx).clamp(0.0, maxX);
      attachment.dy = (attachment.dy + delta.dy).clamp(0.0, maxY);
    });
  }

  void _liftAttachment(JournalAttachment attachment) {
    if (!attachment.usesJournalPlacement) return;
    setState(() => attachment.isPlaced = false);
  }

  void _onAttachmentDragEnd(JournalAttachment attachment, Size paperSize) {
    setState(() {
      final footprint = attachment.footprintSize;
      final maxX = (paperSize.width - footprint.width).clamp(
        0.0,
        double.infinity,
      );
      final maxY = (paperSize.height - footprint.height).clamp(
        0.0,
        double.infinity,
      );

      // Snap to a small grid for a tidy "settle" feel (free placement anywhere on paper).
      double snap(double v) => (v / 8.0).roundToDouble() * 8.0;
      final dx = snap(attachment.dx).clamp(0.0, maxX);
      final dy = snap(attachment.dy).clamp(0.0, maxY);

      if (attachment.usesJournalPlacement) {
        attachment.isPlaced =
            true; // confirm placement on snap/release (photo tape/audio no tape)
      }

      attachment.dx = dx;
      attachment.dy = dy;
    });
  }

  Future<void> _handleMoodAction() async {
    _closeSpeedDial();
    final result = await showJournalMoodPickerSheet(
      context,
      initialMood: _selectedMood,
      initialIntensity: _moodIntensity,
    );
    if (!mounted || result == null) return;
    setState(() {
      _selectedMood = result.mood;
      _moodIntensity = result.intensity;
    });
  }

  Future<void> _handleAttach() async {
    _closeSpeedDial();
    final action = await showJournalAttachmentPickerSheet(context);
    if (!mounted || action == null) return;
    switch (action) {
      case JournalAttachmentAction.camera:
        _addAttachment(JournalAttachmentKind.image, 'photo', 'Camera capture');
        _showHint('Photo attachment added (placeholder)');
        break;
      case JournalAttachmentAction.photoLibrary:
        _addAttachment(JournalAttachmentKind.image, 'photo', 'From library');
        _showHint('Photo attachment added (placeholder)');
        break;
      case JournalAttachmentAction.file:
        _addAttachment(JournalAttachmentKind.file, 'file', 'Attached document');
        _showHint('File attachment added (placeholder)');
        break;
    }
  }

  void _handleVoice() {
    _closeSpeedDial();
    _addAttachment(JournalAttachmentKind.voice, 'voice note', '0:24');
    _showHint('Voice note added');
  }

  void _handleTagAction() {
    _closeSpeedDial();
    _addTag();
  }

  void _handlePredict() {
    _closeSpeedDial();
    setState(() {
      if (_prediction == null) {
        _prediction = _PredictionData(
          text: 'I will feel more at ease after taking a short walk.',
          dueLabel: 'Due: 19 Nov',
          confidence: 'Medium',
        );
      } else {
        _prediction = null;
      }
    });
  }

  void _handleReply() {
    _closeSpeedDial();
    setState(() {
      if (_reply == null) {
        _reply = const _ReplyData(
          sourceLabel: 'Replying to your entry from 5 Nov 2025',
          quote: '“You were worried about the week ahead, but you made it through.”',
        );
      } else {
        _reply = null;
      }
    });
  }

  void _handleToggleLongPress() {
    _showHint('Hold to record');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                JournalEditorAppBar(
                  isSaved: _saved,
                  onClose: _closeEditor,
                  onDone: _markDone,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final minPaperHeight = (constraints.maxHeight - 12 - 120)
                          .clamp(520.0, double.infinity);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                        child: JournalEditorPaper(
                          minHeight: minPaperHeight,
                          attachments: _attachments,
                          onMoveAttachment: _moveAttachment,
                          onAttachmentDragEnd: _onAttachmentDragEnd,
                          onLiftAttachment: _liftAttachment,
                          onRemoveAttachment: _removeAttachment,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              JournalEditorTitle(controller: _titleController),
                              const SizedBox(height: 20),
                              JournalEditorBody(controller: _bodyController),
                              if (_tags.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                JournalEditorTags(
                                  tags: _tags,
                                  onRemoveTag: _removeTag,
                                ),
                              ],
                              if (_reply != null) ...[
                                const SizedBox(height: 12),
                                JournalEditorReplyCard(
                                  sourceLabel: _reply!.sourceLabel,
                                  quote: _reply!.quote,
                                  onRemove: () => setState(() => _reply = null),
                                ),
                              ],
                              if (_prediction != null) ...[
                                const SizedBox(height: 12),
                                JournalEditorPredictionBlock(
                                  predictionText: _prediction!.text,
                                  dueLabel: _prediction!.dueLabel,
                                  confidence: _prediction!.confidence,
                                  confidenceOptions: _confidenceOptions,
                                  onConfidenceChanged: (value) {
                                    setState(
                                      () => _prediction!.confidence = value,
                                    );
                                  },
                                  onRemove: () =>
                                      setState(() => _prediction = null),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (_speedDialOpen)
              JournalEditorSpeedDialScrim(onClose: _closeSpeedDial),
            JournalEditorSpeedDial(
              open: _speedDialOpen,
              onClosed: _closeSpeedDial,
              selectedMood: _selectedMood?.inlineLabel,
              attachmentCount: _attachmentCount,
              hasPrediction: _prediction != null,
              hasReply: _reply != null,
              onAttach: _handleAttach,
              onVoice: _handleVoice,
              onMood: _handleMoodAction,
              onTag: _handleTagAction,
              onPredict: _handlePredict,
              onReply: _handleReply,
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: JournalEditorToolToggle(
                open: _speedDialOpen,
                onToggled: _toggleSpeedDial,
                onLongPress: _handleToggleLongPress,
                badgeCount: _extrasCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
