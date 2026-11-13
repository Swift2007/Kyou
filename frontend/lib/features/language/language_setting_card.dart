// Responsibility: Language setting card — label, description, and dropdown
// field. 342×84 per OpenPencil frame tree.
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'language_dropdown.dart';

class LanguageSettingCard extends StatelessWidget {
  final String selectedLanguage;
  final bool dropdownOpen;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onDropdownToggled;

  const LanguageSettingCard({
    super.key,
    required this.selectedLanguage,
    required this.dropdownOpen,
    required this.onLanguageChanged,
    required this.onDropdownToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 84,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Used for menus, buttons, and settings.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LanguageDropdown(
              selectedLanguage: selectedLanguage,
              dropdownOpen: dropdownOpen,
              onLanguageChanged: onLanguageChanged,
              onDropdownToggled: onDropdownToggled,
            ),
          ],
        ),
      ),
    );
  }
}
