import 'package:flutter/material.dart';

/// The palette shared by the EduSnap book/camera mark and Session 4.
abstract final class AppTheme {
  static const primary = Color(0xFF025928);
  static const secondary = Color(0xFFF25D27);
  static const accent = Color(0xFFD9653B);
  static const surface = Color(0xFFF2B29B);
  static const background = Color(0xFFF2F2F2);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.black,
      tertiary: accent,
      onTertiary: Colors.black,
      surface: surface,
      onSurface: const Color(0xFF201A17),
      surfaceContainerHighest: background,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(color: scheme.surface),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.tertiary,
      ),
    );
  }
}
