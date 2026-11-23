// Responsibility: Attachment picker bottom sheet — add entry attachments.
// Voice is handled via the speed dial only (to keep the sheet focused/spacious).
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

enum JournalAttachmentAction { camera, photoLibrary, file }

Future<JournalAttachmentAction?> showJournalAttachmentPickerSheet(
  BuildContext context,
) {
  return showModalBottomSheet<JournalAttachmentAction>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.ink.withValues(alpha: 0.18),
    builder: (context) => const _AttachmentPickerSheet(),
  );
}

class _AttachmentPickerSheet extends StatelessWidget {
  const _AttachmentPickerSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.rule,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add to entry',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              _AttachmentRow(
                icon: Icons.photo_camera_outlined,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: () => Navigator.of(context).pop(JournalAttachmentAction.camera),
              ),
              _AttachmentRow(
                icon: Icons.photo_library_outlined,
                title: 'Photo library',
                subtitle: 'Choose photos',
                onTap: () =>
                    Navigator.of(context).pop(JournalAttachmentAction.photoLibrary),
              ),
              _AttachmentRow(
                icon: Icons.attach_file_outlined,
                title: 'File',
                subtitle: 'Attach a file',
                onTap: () => Navigator.of(context).pop(JournalAttachmentAction.file),
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _AttachmentRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.ink, width: 2),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.ink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Mono',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, thickness: 1, color: AppColors.rule),
        ],
      ),
    );
  }
}
