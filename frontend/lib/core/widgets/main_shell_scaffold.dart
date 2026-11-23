// Responsibility: Persistent app shell for Home/Journal/Profile tabs.
// Keeps bottom dock static while switching tab content.
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import 'app_bottom_dock.dart';

class MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({super.key, required this.navigationShell});

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: AppBottomDock(
        currentIndex: currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
