// Responsibility: Entry row widget (avatar + title + subtitle + time) and
// divider used in the home dashboard recent-entries list. Extracted from home_dashboard_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeEntryRow extends StatelessWidget {
  const HomeEntryRow({
    super.key,
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

class HomeDivider extends StatelessWidget {
  const HomeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Container(
        height: 1,
        color: const Color(0xFF191916).withValues(alpha: 0.1),
      ),
    );
  }
}
