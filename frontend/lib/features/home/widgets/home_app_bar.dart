// Responsibility: Home app bar — avatar, name, streak badge, edit button.
// Flat style per OpenPencil Home screen (2px strokes, no shadows).
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback? onEdit;
  const HomeAppBar({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          alignment: Alignment.center,
          child: const Text(
            'S',
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Sam Smith',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            '🔥 12',
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF5F5F5),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(19),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}
