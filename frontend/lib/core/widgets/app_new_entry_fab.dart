// Responsibility: Shared "New entry" FAB for main screens.
// Same as Insights: accent circle, 3px ink border, hard offset shadow,
// anchored popup menu with "Create a new journal" action.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class AppNewEntryFab extends StatelessWidget {
  const AppNewEntryFab({super.key});

  Future<void> _showMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final fabTopLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromLTRB(
      fabTopLeft.dx - 220,
      fabTopLeft.dy - 120,
      overlay.size.width - fabTopLeft.dx - box.size.width,
      overlay.size.height - fabTopLeft.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.ink, width: 3),
      ),
      items: [
        const PopupMenuItem<String>(
          enabled: false,
          height: 32,
          child: Text(
            'New entry',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              fontSize: 14,
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'create_journal',
          child: Row(
            children: const [
              Icon(Icons.book_outlined, size: 20, color: AppColors.ink),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Create a new journal',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.ink),
            ],
          ),
        ),
      ],
    );

    if (selected == 'create_journal' && context.mounted) {
      context.push('/create-journal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _showMenu(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.ink, offset: Offset(2, 2), blurRadius: 0),
            ],
          ),
          child: const Center(
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
