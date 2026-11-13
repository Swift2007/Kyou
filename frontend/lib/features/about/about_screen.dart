// Responsibility: Renders the About screen matching the OpenPencil
// About page (page_id 0:54, frame 0:1906 light / 0:1940 dark, 390x844).
// No status bar per user instruction.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import 'about_app_bar.dart';
import 'about_app_info_card.dart';
import 'about_link_row.dart';
import 'footer_note.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const AboutAppBar(),
            const SizedBox(height: 16),

            // App info card
            const AboutAppInfoCard(),
            const SizedBox(height: 20),

            // Section header + link rows
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 14),

            const AboutLinkRow(
              label: "What's new",
              desc: 'See recent updates',
            ),
            const SizedBox(height: 10),
            const AboutLinkRow(
              label: 'Privacy Policy',
              desc: 'How your data is handled',
            ),
            const SizedBox(height: 10),
            const AboutLinkRow(
              label: 'Terms of Service',
              desc: 'Rules for using Kyou',
            ),
            const SizedBox(height: 10),
            const AboutLinkRow(
              label: 'Acknowledgements',
              desc: 'Libraries and credits',
            ),
            const SizedBox(height: 10),
            const AboutLinkRow(
              label: 'Contact support',
              desc: 'Get help or send feedback',
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
