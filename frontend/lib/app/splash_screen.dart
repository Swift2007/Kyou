// Responsibility: Branded splash screen shown while Supabase initializes.
// Uses the app's neobrutalist cream/orange palette so the first thing the
// user sees matches the app identity, not a blank white screen.
import 'package:flutter/material.dart';

import '../core/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: AppColors.ink, offset: Offset(4, 4)),
                ],
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 48,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text('Kyou', style: AppTextStyles.headline(fontSize: 40)),
            const SizedBox(height: 16),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
