// Responsibility: Bottom navigation item (icon + label + active dot) used in
// the home dashboard bottom nav bar. Extracted from home_dashboard_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeNavItem extends StatelessWidget {
  const HomeNavItem({
    super.key,
    required this.label,
    required this.active,
    required this.icon,
  });

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
