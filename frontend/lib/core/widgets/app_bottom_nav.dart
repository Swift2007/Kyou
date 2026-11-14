// Responsibility: Compatibility export for bottom navigation.
// Phase 2+: prefer AppBottomDock (rounded raised 3-tab pill + separate FAB).
export 'app_bottom_dock.dart' show AppTab, AppBottomDock;

// Backwards-compatible alias used by existing screens.
import 'app_bottom_dock.dart';

typedef AppBottomNav = AppBottomDock;
