// Responsibility: Language dropdown field + open menu.
// Two languages: English (default) and Japanese (日本語).
// Field: 140×40 per OpenPencil. Dropdown menu: 140×88 per OpenPencil.
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final bool dropdownOpen;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onDropdownToggled;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.dropdownOpen,
    required this.onLanguageChanged,
    required this.onDropdownToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown field — 140×40
        GestureDetector(
          onTap: onDropdownToggled,
          child: Container(
            width: 140,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.ink, width: 3),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  selectedLanguage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Text(
                    '⌄',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Open dropdown menu — 140×88
        if (dropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            width: 140,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.ink, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.ink,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // English option (selected)
                _LanguageOption(
                  label: 'English',
                  nativeLabel: 'English',
                  isSelected: selectedLanguage == 'English',
                  onSelected: () => onLanguageChanged('English'),
                ),
                const SizedBox(height: 1),
                _MenuDivider(),
                // Japanese option
                _LanguageOption(
                  label: 'Japanese',
                  nativeLabel: '日本語',
                  isSelected: selectedLanguage == 'Japanese',
                  onSelected: () => onLanguageChanged('Japanese'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String nativeLabel;
  final bool isSelected;
  final VoidCallback onSelected;

  const _LanguageOption({
    required this.label,
    required this.nativeLabel,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        width: 132,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              const Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: Text(
                  '✓',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(width: 18),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 2),
                    child: Text(
                      nativeLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 1,
      color: AppColors.ink,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
