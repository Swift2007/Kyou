// Responsibility: Footer note text at bottom of Notifications screen.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class FooterNote extends StatelessWidget {
  const FooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Kyou keeps notifications calm and intentional.',
      style: TextStyle(fontFamily: 'Inter', fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      textAlign: TextAlign.center,
    );
  }
}
