// Responsibility: Shared "New entry" FAB for main screens.
// Opens anchored menu and routes to journal entry editor.
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class AppNewEntryFab extends StatelessWidget {
  const AppNewEntryFab({super.key});

  Future<void> _showMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final fabTopLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromLTRB(
      fabTopLeft.dx - 220,
      fabTopLeft.dy - 112,
      overlay.size.width - fabTopLeft.dx - box.size.width,
      overlay.size.height - fabTopLeft.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.ink, width: 2),
      ),
      items: const [
        PopupMenuItem<String>(
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
        PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'new_entry',
          child: Row(
            children: [
              Icon(Icons.edit_note_outlined, size: 20, color: AppColors.ink),
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

    if (!context.mounted) return;
    if (selected == 'new_entry') {
      context.push('/entries/new');
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
            child: Icon(Icons.add, size: 30, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}
