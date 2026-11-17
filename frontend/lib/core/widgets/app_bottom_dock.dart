// Responsibility: Shared bottom dock for main tab shell.
// Rounded, raised 3-tab nav pill (Home/Journal/Profile) with separate FAB.
import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'app_new_entry_fab.dart';

enum AppTab { home, journal, profile }

class AppBottomDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomDock({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
                child: Row(
                  children: [
                    _DockItem(
                      label: 'Home',
                      icon: Icons.home_outlined,
                      active: currentIndex == 0,
                      onTap: () => onTabSelected(0),
                    ),
                    _DockItem(
                      label: 'Journal',
                      icon: Icons.book_outlined,
                      active: currentIndex == 1,
                      onTap: () => onTabSelected(1),
                    ),
                    _DockItem(
                      label: 'Profile',
                      icon: Icons.person_outline,
                      active: currentIndex == 2,
                      onTap: () => onTabSelected(2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            const AppNewEntryFab(),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _DockItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.ink : AppColors.muted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
              child: active
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
