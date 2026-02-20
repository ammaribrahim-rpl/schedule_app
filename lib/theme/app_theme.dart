import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP THEME
// Color palette:
//   Light: Warm cream #F5F0E8 bg · Forest green #2D4A3E primary · #1C2E28 text
//   Dark:  Ink navy #131B2E bg · Muted gold #C9A84C primary · #E8E2D6 text
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  // Light mode colors
  static const Color _lightSurface = Color(0xFFF5F0E8);
  static const Color _lightSurfaceVariant = Color(0xFFEAE3D6);
  static const Color _lightPrimary = Color(0xFF2D4A3E);
  static const Color _lightOnPrimary = Color(0xFFF5F0E8);
  static const Color _lightOnSurface = Color(0xFF1C2E28);
  static const Color _lightError = Color(0xFFB85C4A);

  // Dark mode colors
  static const Color _darkSurface = Color(0xFF131B2E);
  static const Color _darkSurfaceVariant = Color(0xFF1D2840);
  static const Color _darkPrimary = Color(0xFFC9A84C);
  static const Color _darkOnPrimary = Color(0xFF131B2E);
  static const Color _darkOnSurface = Color(0xFFE8E2D6);
  static const Color _darkError = Color(0xFFE07C6B);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: _lightOnPrimary,
        primaryContainer: Color(0xFFD2E5DD),
        onPrimaryContainer: _lightPrimary,
        secondary: Color(0xFF7A5C3A),
        onSecondary: _lightSurface,
        secondaryContainer: Color(0xFFEAD8C4),
        onSecondaryContainer: Color(0xFF5A3D20),
        tertiary: Color(0xFF8A6A2A),
        onTertiary: _lightSurface,
        tertiaryContainer: Color(0xFFEAD89A),
        onTertiaryContainer: Color(0xFF5A4010),
        error: _lightError,
        onError: _lightSurface,
        errorContainer: Color(0xFFF2CECA),
        onErrorContainer: Color(0xFF8A2A20),
        surface: _lightSurface,
        onSurface: _lightOnSurface,
        surfaceVariant: _lightSurfaceVariant,
        onSurfaceVariant: Color(0xFF4A5E54),
        outline: Color(0xFFB0A898),
        outlineVariant: Color(0xFFD4CBB8),
        shadow: Color(0x1A1C2E28),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF1C2E28),
        onInverseSurface: _lightSurface,
        inversePrimary: Color(0xFF8CB8A4),
      ),
      fontFamily: 'SF Pro Display', // Falls back to system font gracefully
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _lightOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _lightSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightOnSurface,
        contentTextStyle: const TextStyle(color: _lightSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceVariant.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: Color(0xFF9AA89E),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFDDD6CA),
        thickness: 1,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: _darkOnPrimary,
        primaryContainer: Color(0xFF3D3018),
        onPrimaryContainer: _darkPrimary,
        secondary: Color(0xFFB8906A),
        onSecondary: _darkSurface,
        secondaryContainer: Color(0xFF3D2C18),
        onSecondaryContainer: Color(0xFFD4B08A),
        tertiary: Color(0xFF9A8850),
        onTertiary: _darkSurface,
        tertiaryContainer: Color(0xFF3A3018),
        onTertiaryContainer: Color(0xFFCAB880),
        error: _darkError,
        onError: _darkSurface,
        errorContainer: Color(0xFF4A1810),
        onErrorContainer: Color(0xFFF0A898),
        surface: _darkSurface,
        onSurface: _darkOnSurface,
        surfaceVariant: _darkSurfaceVariant,
        onSurfaceVariant: Color(0xFFB8B0A0),
        outline: Color(0xFF3D4A60),
        outlineVariant: Color(0xFF2A3445),
        shadow: Color(0x660D1020),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE8E2D6),
        onInverseSurface: _darkSurface,
        inversePrimary: Color(0xFF2D4A3E),
      ),
      fontFamily: 'SF Pro Display',
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkOnSurface,
        contentTextStyle: const TextStyle(color: _darkSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceVariant.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: Color(0xFF5A6A80),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF252F45),
        thickness: 1,
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light
        ? const Color(0xFF1C2E28)
        : const Color(0xFFE8E2D6);

    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
          color: baseColor),
      displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          color: baseColor),
      displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          color: baseColor),
      headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
          color: baseColor),
      headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: baseColor),
      headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: baseColor),
      titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: baseColor),
      titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: baseColor),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: baseColor),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: baseColor),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: baseColor),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: baseColor),
      labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: baseColor),
      labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: baseColor),
      labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: baseColor),
    );
  }
}