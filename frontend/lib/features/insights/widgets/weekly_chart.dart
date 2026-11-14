// Responsibility: Weekly bar chart (MON-SUN) matching OpenPencil Insights.
// Plain chart area (no elevated card wrapper). THU bar accented.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  // Bar heights matching OpenPencil (0:1196-0:1209):
  // MON: 40, TUE: 65, WED: 30, THU: 80, FRI: 55, SAT: 70, SUN: 45
  static const List<BarData> _bars = [
    BarData('MON', 40),
    BarData('TUE', 65),
    BarData('WED', 30),
    BarData('THU', 80, accent: true),
    BarData('FRI', 55),
    BarData('SAT', 70),
    BarData('SUN', 45),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _bars
            .map(
              (bar) => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: bar.height,
                      decoration: BoxDecoration(
                        color: bar.accent ? AppColors.accent : AppColors.ink,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bar.label,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BarData {
  final String label;
  final double height;
  final bool accent;
  const BarData(this.label, this.height, {this.accent = false});
}
