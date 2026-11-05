// Responsibility: Defines the Material 3 color scheme and text theme.
import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF4F46E5),
      brightness: Brightness.light,
    ),
  );
}
