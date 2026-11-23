// Responsibility: "Continue with Google" button. Signs in via Supabase OAuth when tapped.
// Extracted from journal_kit.dart.
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'journal_colors.dart';

/// "Continue with Google" button. Signs in via Supabase OAuth when tapped.
class JournalGoogleButton extends StatelessWidget {
  const JournalGoogleButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: JournalColors.page,
        border: Border.all(color: JournalColors.ink, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: JournalColors.ink,
                      height: 17 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
