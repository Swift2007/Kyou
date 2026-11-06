// Responsibility: Renders the Home screen dashboard matching the OpenPencil Home UI prototype.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_viewmodel.dart';

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
                const _AppBar(),
                const SizedBox(height: 10),
                const _CalendarCard(),
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
                const _EntryRow(
                  initial: 'A',
                  title: 'Monday, Oct 13',
                  subtitle: 'This week was heavy. Wrote it anyway.',
                  time: '2h ago',
                ),
                const _Divider(),
                const _EntryRow(
                  initial: 'B',
                  title: 'Tuesday, Oct 14',
                  subtitle: 'Some days just need a quieter list.',
                  time: '1d ago',
                ),
                const _Divider(),
                const _EntryRow(
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
                          child: _NavItem(label: 'Home', active: true, icon: Icons.home_outlined),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/entries'),
                          child: _NavItem(label: 'Insights', active: false, icon: Icons.bar_chart_outlined),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/entries'),
                          child: _NavItem(label: 'Journal', active: false, icon: Icons.book_outlined),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/entries'),
                          child: _NavItem(label: 'Profile', active: false, icon: Icons.person_outline),
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

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
      child: Row(
        children: [
          Text(
            '9:41',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191916),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _StatusIcon(path: 'assets/icons/signal.png'),
              const SizedBox(width: 5),
              _StatusIcon(path: 'assets/icons/wifi.png'),
              const SizedBox(width: 5),
              _StatusIcon(path: 'assets/icons/battery.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    // Fallback to simple shapes if assets not present
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _DotPainter(),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF191916);
    canvas.drawRect(Rect.fromLTWH(2, 3, 2, 2), paint);
    canvas.drawRect(Rect.fromLTWH(6, 2, 2, 3), paint);
    canvas.drawRect(Rect.fromLTWH(10, 1, 2, 4), paint);
    canvas.drawRect(Rect.fromLTWH(14, 0, 2, 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AppBar extends ConsumerWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF191916), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF191916),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'S',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF191916),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Sam Smith',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191916),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF191916), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF191916),
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final d in ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'])
                        SizedBox(
                          width: 42,
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              color: const Color(0xFF625F55),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CalDay('15'),
                      _CalDay('16'),
                      _CalDay('17'),
                      _CalDay('18', isToday: true),
                      _CalDay('19'),
                      _CalDay('20'),
                      _CalDay('21'),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('<',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF625F55))),
                  Text('>',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF625F55))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalDay extends StatelessWidget {
  const _CalDay(this.day, {this.isToday = false});
  final String day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    if (isToday) {
      return SizedBox(
        width: 42,
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFF623C),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              day,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191916),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: 42,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF625F55),
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.initial,
    required this.title,
    required this.subtitle,
    required this.time,
  });
  final String initial;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF191916), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF191916),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF191916),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191916),
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF625F55),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              color: const Color(0xFF625F55),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Container(
        height: 1,
        color: const Color(0xFF191916).withOpacity(0.1),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF5),
        border: Border(
          top: BorderSide(color: Color(0xFF191916), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: _NavItem(label: 'Home', active: true, icon: Icons.home_outlined),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(label: 'Insights', active: false, icon: Icons.bar_chart_outlined),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(label: 'Journal', active: false, icon: Icons.book_outlined),
          ),
          GestureDetector(
            onTap: () => context.go('/entries'),
            child: _NavItem(label: 'Profile', active: false, icon: Icons.person_outline),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.active, required this.icon});
  final String label;
  final bool active;
  final IconData icon;

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
              color: Color(0xFFFF623C),
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 8),
        Icon(icon, size: 22, color: const Color(0xFF625F55)),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF625F55),
          ),
        ),
      ],
    );
  }
}
