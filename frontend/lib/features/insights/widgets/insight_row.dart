// Responsibility: Recent insight card — "You write most on Wednesdays.
// Keep the momentum going." Flat/brutal card (2px border, no shadow).
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class InsightRow extends StatelessWidget {
  final bool compact;
  const InsightRow({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final horizontal = compact ? 14.0 : 20.0;
    final vertical = compact ? 10.0 : 12.0;
    final titleSize = compact ? 14.0 : 16.0;
    final bodySize = compact ? 12.0 : 14.0;
    final gap = compact ? 2.0 : 4.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You write most on Wednesdays.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.2,
            ),
          ),
          SizedBox(height: gap),
          Text(
            'Keep the momentum going.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: bodySize,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
