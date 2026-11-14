// Responsibility: Mini calendar card showing weekday headers and day chips,
// matching the OpenPencil Home UI prototype. Extracted from home_dashboard_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCalendarCard extends StatelessWidget {
  const HomeCalendarCard({super.key});

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
                      for (final d in [
                        'SUN',
                        'MON',
                        'TUE',
                        'WED',
                        'THU',
                        'FRI',
                        'SAT',
                      ])
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
                      CalDay('15'),
                      CalDay('16'),
                      CalDay('17'),
                      CalDay('18', isToday: true),
                      CalDay('19'),
                      CalDay('20'),
                      CalDay('21'),
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
                  Text(
                    '<',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF625F55),
                    ),
                  ),
                  Text(
                    '>',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF625F55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalDay extends StatelessWidget {
  const CalDay(this.day, {this.isToday = false, super.key});

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
        style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF625F55)),
      ),
    );
  }
}
