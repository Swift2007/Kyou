// Responsibility: iOS home indicator pill (134x5) shown at the bottom of
// the insights screen. Extracted from insights_screen.dart.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
