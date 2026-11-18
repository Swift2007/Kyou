// Responsibility: Footer note text at bottom of About screen.
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

class FooterNote extends StatelessWidget {
  const FooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Made with care for your daily reflections.',
      style: TextStyle(fontFamily: 'Inter', fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      textAlign: TextAlign.center,
    );
  }
}
