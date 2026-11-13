// Responsibility: Renders the Language screen matching the OpenPencil
// Language page (page_id 0:59, frames 0:3349 closed / 0:3326 open, 390x844).
// Only two languages: English (default) and Japanese (日本語).
// No status bar per user instruction.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

import 'language_app_bar.dart';
import 'language_setting_card.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool _dropdownOpen = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const LanguageAppBar(),
            const SizedBox(height: 16),

            // Section header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'APP LANGUAGE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Language setting card with dropdown
            LanguageSettingCard(
              selectedLanguage: _selectedLanguage,
              dropdownOpen: _dropdownOpen,
              onLanguageChanged: (lang) {
                setState(() {
                  _selectedLanguage = lang;
                  _dropdownOpen = false;
                });
              },
              onDropdownToggled: () {
                setState(() {
                  _dropdownOpen = !_dropdownOpen;
                });
              },
            ),
            const SizedBox(height: 14),

            // Helper text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Language changes apply across the app interface. Journal '
                'content stays in the language you wrote it.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                  height: 17 / 11,
                ),
              ),
            ),
            const Spacer(),
            const FooterNote(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class FooterNote extends StatelessWidget {
  const FooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'More languages can be added later.',
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      textAlign: TextAlign.center,
    );
  }
}
