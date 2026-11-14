// Responsibility: Home screen app bar — user avatar + name, matching the
// OpenPencil Home UI prototype. Extracted from home_dashboard_screen.dart.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

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
