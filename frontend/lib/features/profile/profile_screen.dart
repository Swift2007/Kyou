// Responsibility: Profile screen — header and account/menu entry points.
// OpenPencil-aligned (Profile frame 0:1272): flat header, row layout, 8px rhythm.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_bottom_dock.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomDock(activeTab: AppTab.profile),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 144).clamp(0.0, double.infinity),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'PROFILE',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Mono',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppColors.ink, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'S',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Mono',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sam Smith',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '@sam.untitled',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _MenuItem(
                        icon: Icons.person_outline,
                        label: 'Edit profile',
                        onTap: () => context.push('/edit-profile'),
                      ),
                      _MenuItem(
                        icon: Icons.tune_outlined,
                        label: 'Preferences',
                        onTap: () => context.push('/preference'),
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications',
                        onTap: () => context.push('/notifications'),
                      ),
                      _MenuItem(
                        icon: Icons.language_outlined,
                        label: 'Language',
                        onTap: () => context.push('/language'),
                      ),
                      _MenuItem(
                        icon: Icons.info_outline,
                        label: 'About',
                        onTap: () => context.push('/about'),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      _MenuItem(
                        icon: Icons.logout_outlined,
                        label: 'Log out',
                        accent: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool accent;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = accent ? AppColors.accent : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: labelColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: labelColor,
                    ),
                  ),
                ),
                const Text(
                  '›',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
