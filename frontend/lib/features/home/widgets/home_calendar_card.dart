// Responsibility: Home date/calendar strip — minimal layout with year, flat style.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomeCalendarCard extends StatelessWidget {
  const HomeCalendarCard({super.key});

  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _dates = ['15', '16', '17', '18', '19', '20', '21'];
  static const _todayIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.chevron_left, size: 18, color: AppColors.muted),
              Expanded(
                child: Text(
                  'October 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _weekdays
                .map(
                  (d) => Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_dates.length, (i) {
              final isToday = i == _todayIndex;
              return Expanded(
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: isToday
                        ? const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          )
                        : null,
                    alignment: Alignment.center,
                    child: Text(
                      _dates[i],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
