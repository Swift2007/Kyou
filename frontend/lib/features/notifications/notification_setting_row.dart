// Responsibility: Notification setting row — icon + label + description + toggle.
// 342×72 per OpenPencil frame tree.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class NotificationSettingRow extends StatelessWidget {
  final String icon;
  final String label;
  final String desc;
  final bool toggleOn;

  const NotificationSettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.desc,
    this.toggleOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.ink, width: 2),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Label + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 16 / 11,
                    ),
                  ),
                ],
              ),
            ),
            // Toggle + state
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NotificationToggle(on: toggleOn),
                const SizedBox(height: 2),
                Text(
                  toggleOn ? 'On' : 'Off',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationToggle extends StatelessWidget {
  final bool on;

  const NotificationToggle({
    super.key,
    required this.on,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 30,
      decoration: BoxDecoration(
        color: on ? AppColors.accent : AppColors.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.ink, width: 3),
      ),
      child: Align(
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
