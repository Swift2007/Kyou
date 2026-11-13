// Responsibility: Renders the Profile screen matching the OpenPencil
// Home UI prototype exactly (frame 0:1272, 402x874).
// No status bar per user instruction.
//
// Structure from OpenPencil:
// - App bar: "PROFILE" title (0:1282/0:1285)
// - Avatar: "S" initial + "Sam Smith" + "@sam.untitled"
// - Menu items: My Profile >, Preferences >, Notifications >,
//   Transaction History >, About App >, Logout >
// - Bottom nav: Profile active (0:1289)
// - Home indicator (0:1287/0:1288)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // App bar — "PROFILE" title matching OpenPencil 0:1282/0:1285
            const _ProfileAppBar(),
            const SizedBox(height: 24),
            // Avatar + name + handle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _ProfileHeader(),
            ),
            const SizedBox(height: 32),
            // Menu items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _ProfileMenu(),
            ),
            const Spacer(),
            // Bottom navigation — Profile active (OpenPencil 0:1289)
            const _ProfileBottomNav(),
            // Home safe area — iOS home indicator (OpenPencil 0:1287/0:1288)
            Container(
              height: 38,
              color: AppColors.background,
              child: const Center(
                child: _HomeIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAppBar extends ConsumerWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // "PROFILE" title matching OpenPencil 0:1285
          Text(
            'PROFILE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar — "S" initial matching OpenPencil 0:1307/0:1308
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.ink, width: 3),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 31,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Name
        Text(
          'Sam Smith',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        // Handle
        Text(
          '@sam.untitled',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          label: 'My Profile',
          onTap: () {},
        ),
        const Divider(height: 1, color: AppColors.rule, indent: 0, endIndent: 0),
        _MenuItem(
          label: 'Preferences',
          onTap: () {},
        ),
        const Divider(height: 1, color: AppColors.rule, indent: 0, endIndent: 0),
        _MenuItem(
          label: 'Notifications',
          onTap: () {},
        ),
        const Divider(height: 1, color: AppColors.rule, indent: 0, endIndent: 0),
        _MenuItem(
          label: 'About App',
          onTap: () {},
        ),
        const Divider(height: 1, color: AppColors.rule, indent: 0, endIndent: 0),
        _MenuItem(
          label: 'Logout',
          onTap: () {},
          accent: true,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool accent;

  const _MenuItem({
    required this.label,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            const Text(
              '\u203a',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBottomNav extends StatelessWidget {
  const _ProfileBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.ink, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: _NavItem(
              label: 'Home',
              active: false,
              icon: Icons.home_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/insights'),
            child: _NavItem(
              label: 'Insights',
              active: false,
              icon: Icons.bar_chart_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/journal'),
            child: _NavItem(
              label: 'Journal',
              active: false,
              icon: Icons.book_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: _NavItem(
              label: 'Profile',
              active: true,
              icon: Icons.person_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;

  const _NavItem({
    required this.label,
    required this.active,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (active)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 8),
        Icon(
          icon,
          size: 22,
          color: active ? AppColors.ink : AppColors.muted,
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: active ? AppColors.ink : AppColors.muted,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
