// Responsibility: Shared bottom navigation bar for main tab screens
// (Home, Insights, Journal, Profile). Matches OpenPencil Home UI nav:
// 4 items with icon + label, accent dot on active tab, 60px bar height.
// Responsive full-width, no fixed canvas width, no home indicator pill.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

enum AppTab { home, insights, journal, profile }

class AppBottomNav extends StatelessWidget {
  final AppTab activeTab;

  const AppBottomNav({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavItem(
              label: 'Home',
              icon: Icons.home_outlined,
              active: activeTab == AppTab.home,
              onTap: () => context.go('/home'),
            ),
            _NavItem(
              label: 'Insights',
              icon: Icons.bar_chart_outlined,
              active: activeTab == AppTab.insights,
              onTap: () => context.go('/insights'),
            ),
            _NavItem(
              label: 'Journal',
              icon: Icons.book_outlined,
              active: activeTab == AppTab.journal,
              onTap: () => context.go('/journal'),
            ),
            _NavItem(
              label: 'Profile',
              icon: Icons.person_outline,
              active: activeTab == AppTab.profile,
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
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
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
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
