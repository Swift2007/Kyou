// Responsibility: Renders the Journal screen matching the OpenPencil
// Home UI prototype exactly (frame 0:1215, 402x874).
// No status bar per user instruction.
//
// Structure from OpenPencil Journal page:
// - App bar: "JOURNAL" title (0:1225/0:1227)
// - New entry FAB: 56x56 rounded rect with "+" (0:1228/0:1229)
// - Bottom nav: Home / Insights / Journal(active) / Profile (0:1233)
// - Home indicator: 134x5 pill (0:1231/0:1232)
//
// Content (from OpenPencil):
// - Search field: "Search your journal…" (0:1251/0:1252)
// - "YOUR JOURNALS" section header (0:1253)
// - Journal row 1: avatar "M" (0:1254-0:1256)
// - Journal row 2: avatar "G" (0:1257-0:1259)
// - Journal row 3: avatar "T" + "Monday Musings" + "Oct 13 · 2:14 PM" + "Work week reflections and thoughts." (0:1260-0:1265)
// - Journal entry: "Gratitude List" + "Oct 12 · 9:00 AM" + "Today I am grateful for the little things." (0:1266-0:1268)
// - Journal entry: "Travel Notes" + "Oct 10 · 3:30 PM" + "Mountain cabin weekend, fresh air." (0:1269-0:1271)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // App bar — "JOURNAL" title matching OpenPencil 0:1225/0:1227
                const _JournalAppBar(),
                const SizedBox(height: 18),
                // Search field (OpenPencil 0:1251/0:1252)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _JournalSearchField(),
                ),
                const SizedBox(height: 24),
                // YOUR JOURNALS section header (OpenPencil 0:1253)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'YOUR JOURNALS',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.5,
                      height: 18 / 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Journal rows
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _JournalRows(),
                ),
                const Spacer(),
                // Bottom navigation — Journal active (OpenPencil 0:1233)
                const _JournalBottomNav(),
                // Home safe area — iOS home indicator (OpenPencil 0:1231/0:1232)
                Container(
                  height: 38,
                  color: AppColors.background,
                  child: const Center(child: _HomeIndicator()),
                ),
              ],
            ),
            // New entry FAB — 56x56 rounded rect with "+" (OpenPencil 0:1228/0:1229)
            Positioned(
              right: 16,
              bottom: 76,
              child: GestureDetector(
                onTap: () => context.go('/entries/new'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.ink, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.ink,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalAppBar extends ConsumerWidget {
  const _JournalAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // "JOURNAL" title matching OpenPencil 0:1227
          Text(
            'JOURNAL',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // App bar actions area (OpenPencil 0:1226, 84×40)
          const SizedBox(width: 84, height: 40),
        ],
      ),
    );
  }
}

class _JournalSearchField extends StatelessWidget {
  const _JournalSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, size: 20, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search your journal…',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
                height: 19 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRows extends StatelessWidget {
  const _JournalRows();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1 — avatar "M" (OpenPencil 0:1254-0:1256)
        const _JournalRow(title: null, date: null, body: null),
        const SizedBox(height: 1),
        // Row 2 — avatar "G" (OpenPencil 0:1257-0:1259)
        const _JournalRow(title: null, date: null, body: null),
        const SizedBox(height: 1),
        // Row 3 — avatar "T" + title + date + body (OpenPencil 0:1260-0:1265)
        const _JournalRow(
          title: 'Monday Musings',
          date: 'Oct 13 · 2:14 PM',
          body: 'Work week reflections and thoughts.',
        ),
        const SizedBox(height: 1),
        // Journal entry: Gratitude List (0:1266-0:1268)
        const _JournalRow(
          title: 'Gratitude List',
          date: 'Oct 12 · 9:00 AM',
          body: 'Today I am grateful for the little things.',
        ),
        const SizedBox(height: 1),
        // Journal entry: Travel Notes (0:1269-0:1271)
        const _JournalRow(
          title: 'Travel Notes',
          date: 'Oct 10 · 3:30 PM',
          body: 'Mountain cabin weekend, fresh air.',
        ),
      ],
    );
  }
}

class _JournalRow extends StatelessWidget {
  final String? title;
  final String? date;
  final String? body;

  const _JournalRow({this.title, this.date, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 69,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  height: 21 / 17,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    date ?? '',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 14 / 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (body != null)
                Text(
                  body!,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                    height: 17 / 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _JournalBottomNav extends StatelessWidget {
  const _JournalBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
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
              active: true,
              icon: Icons.book_outlined,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(
              label: 'Profile',
              active: false,
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
        Icon(icon, size: 22, color: active ? AppColors.ink : AppColors.muted),
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
