// Responsibility: Editor top bar — close, date chip, draft/saved status,
// lock affordance, and Done action. Responsive, OpenPencil-aligned (full-width bar).
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class JournalEditorAppBar extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onClose;
  final VoidCallback onDone;

  const JournalEditorAppBar({
    super.key,
    required this.isSaved,
    required this.onClose,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = isSaved ? 'Saved' : 'Draft';
    final statusDotColor =
        isSaved ? const Color(0xFF4A8F5A) : AppColors.accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.ink, width: 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconTapTarget(
            onTap: onClose,
            child: const Text(
              '×',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.ink, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.ink,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Thu, 5 Nov',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _IconTapTarget(
            onTap: () {},
            child: const Icon(
              Icons.lock_outline,
              size: 18,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDone,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.ink, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTapTarget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _IconTapTarget({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(child: child),
      ),
    );
  }
}
