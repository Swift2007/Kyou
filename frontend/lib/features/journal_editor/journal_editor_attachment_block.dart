// Responsibility: Reorderable attachment block widgets and models.
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

enum JournalAttachmentKind { voice, image, file }

class JournalAttachment {
  final String id;
  final JournalAttachmentKind kind;
  final String title;
  final String subtitle;

  const JournalAttachment({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
  });
}

class JournalEditorAttachmentBlock extends StatelessWidget {
  final JournalAttachment attachment;
  final int index;
  final VoidCallback? onRemove;

  const JournalEditorAttachmentBlock({
    super.key,
    required this.attachment,
    required this.index,
    this.onRemove,
  });

  IconData get _icon {
    switch (attachment.kind) {
      case JournalAttachmentKind.voice:
        return Icons.graphic_eq;
      case JournalAttachmentKind.image:
        return Icons.image_outlined;
      case JournalAttachmentKind.file:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>(attachment.id),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.drag_indicator, size: 20, color: AppColors.muted),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Icon(_icon, size: 16, color: AppColors.ink),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.title,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  attachment.subtitle,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, size: 16, color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}
