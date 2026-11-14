// Responsibility: Renders the Home screen dashboard matching the OpenPencil Home UI prototype.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/home_app_bar.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_calendar_card.dart';
import 'widgets/home_entry_row.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  static const _bg = Color(0xFFF3EEDF);
  static const _ink = Color(0xFF191916);
  static const _muted = Color(0xFF625F55);
  static const _accent = Color(0xFFFF623C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                const HomeAppBar(),
                const SizedBox(height: 10),
                const HomeCalendarCard(),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RECENT ENTRIES',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _muted,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const HomeEntryRow(
                  initial: 'A',
                  title: 'Monday, Oct 13',
                  subtitle: 'This week was heavy. Wrote it anyway.',
                  time: '2h ago',
                ),
                const HomeDivider(),
                const HomeEntryRow(
                  initial: 'B',
                  title: 'Tuesday, Oct 14',
                  subtitle: 'Some days just need a quieter list.',
                  time: '1d ago',
                ),
                const HomeDivider(),
                const HomeEntryRow(
                  initial: 'C',
                  title: 'Wednesday, Oct 15',
                  subtitle: 'The center holds.',
                  time: '2d ago',
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 90,
              child: GestureDetector(
                onTap: () => context.push('/entries/new'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: _ink,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                    border: Border.all(color: _ink, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF5),
                  border: Border(
                    top: BorderSide(color: Color(0xFF191916), width: 3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF191916),
                      offset: Offset(0, -3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/home'),
                          child: HomeNavItem(
                            label: 'Home',
                            active: true,
                            icon: Icons.home_outlined,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/insights'),
                          child: HomeNavItem(
                            label: 'Insights',
                            active: false,
                            icon: Icons.bar_chart_outlined,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/journal'),
                          child: HomeNavItem(
                            label: 'Journal',
                            active: false,
                            icon: Icons.book_outlined,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/entries'),
                          child: HomeNavItem(
                            label: 'Profile',
                            active: false,
                            icon: Icons.person_outlined,
                          ),
                        ),
                      ],
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
