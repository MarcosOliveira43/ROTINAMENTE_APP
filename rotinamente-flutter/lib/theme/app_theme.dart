import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppBorders {
  static const BorderRadius rounded16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius rounded24 = BorderRadius.all(Radius.circular(24));
}

class AppTheme {
  static const int _seedColor = 0xFF7B74FF;

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(_seedColor),
      brightness: Brightness.light,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      // Card theme intentionally omitted to avoid SDK type mismatch;
      // use `AppBorders` and colorScheme directly in widgets when needed.
    );

    return base.copyWith(
      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(140, 52),
          shape: RoundedRectangleBorder(borderRadius: AppBorders.rounded16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(140, 52),
          shape: RoundedRectangleBorder(borderRadius: AppBorders.rounded16),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: AppBorders.rounded16),
        ),
      ),
      // Input decorations (e.g., DropdownButtonFormField)
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: AppBorders.rounded16),
      ),
      // Use color scheme copies for consistent surface colors
      colorScheme: colorScheme,
    );
  }
}
