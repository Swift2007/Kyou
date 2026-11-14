// Responsibility: Shared bottom dock for main tab screens.
// Rounded, raised 3-tab nav pill (Home/Journal/Profile) with a separate
// FAB on the right (iOS-like). Insights is not shown in the nav.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import 'app_new_entry_fab.dart';

enum AppTab { home, insights, journal, profile }

class AppBottomDock extends StatelessWidget {
  final AppTab activeTab;

  const AppBottomDock({super.key, required this.activeTab});

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
                      active: activeTab == AppTab.home,
                      onTap: () => context.go('/home'),
                    ),
                    _DockItem(
                      label: 'Journal',
                      icon: Icons.book_outlined,
                      active: activeTab == AppTab.journal,
                      onTap: () => context.go('/journal'),
                    ),
                    _DockItem(
                      label: 'Profile',
                      icon: Icons.person_outline,
                      active: activeTab == AppTab.profile,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: AppNewEntryFab(),
            ),
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
