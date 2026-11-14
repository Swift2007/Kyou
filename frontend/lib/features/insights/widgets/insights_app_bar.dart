// Responsibility: Insights screen app bar — "INSIGHTS" title.
// Matches OpenPencil: IBM Plex Mono, 20px, bold.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class InsightsAppBar extends StatelessWidget {
  const InsightsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'INSIGHTS',
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          height: 1.2,
        ),
      ),
    );
  }
}
