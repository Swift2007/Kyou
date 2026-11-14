// Responsibility: Weekly bar chart (7 bars MON-SUN with varying heights)
// and BarData model. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  // Bar heights matching OpenPencil (0:1196-0:1209):
  // MON: 40, TUE: 65, WED: 30, THU: 80, FRI: 55, SAT: 70, SUN: 45
  static const List<BarData> _bars = [
    BarData('MON', 40.0),
    BarData('TUE', 65.0),
    BarData('WED', 30.0),
    BarData('THU', 80.0),
    BarData('FRI', 55.0),
    BarData('SAT', 70.0),
    BarData('SUN', 45.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 132,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        children: [
          // Bars row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _bars.map((bar) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: bar.height,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.ink, width: 2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bar.label,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted,
                        height: 16 / 13,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BarData {
  final String label;
  final double height;

  const BarData(this.label, this.height);
}
