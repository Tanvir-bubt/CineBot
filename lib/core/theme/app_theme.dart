import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF574DDB);

  // Backgrounds
  static const Color background = Color(0xFF0B0B10);
  static const Color surface = Color(0xFF15151D);
  static const Color surfaceLight = Color(0xFF1D1D27);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA6A6B0);
  static const Color textMuted = Color(0xFF6F6F7A);

  // Status
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFFFC857);
  static const Color error = Color(0xFFFF5C70);

  // Radius
  static const double radiusSmall = 10;
  static const double radiusMedium = 16;
  static const double radiusLarge = 24;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        error: error,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            );
          }

          return const TextStyle(color: textMuted, fontWeight: FontWeight.w500);
        }),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: const IconThemeData(color: primary),
        unselectedIconTheme: const IconThemeData(color: textMuted),
        selectedLabelTextStyle: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: primary.withValues(alpha: 0.18),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textMuted, fontSize: 12),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    );
  }
}
