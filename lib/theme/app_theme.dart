import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP THEME — Deep Space + Electric Violet
//   Light: #F0EEFF (lavender paper) bg · #5B21B6 (deep violet) primary
//   Dark:  #0B0715 (near-black space) bg · #7C3AED (electric violet) primary
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  // ── Light palette ──────────────────────────────────────────────────────────
  static const Color _lightSurface = Color(0xFFF0EEFF);
  static const Color _lightSurfaceVar = Color(0xFFE4DAFF);
  static const Color _lightPrimary = Color(0xFF5B21B6);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnSurface = Color(0xFF1A0833);
  static const Color _lightSecondary = Color(0xFF9333EA);
  static const Color _lightError = Color(0xFFB91C1C);

  // ── Dark palette ───────────────────────────────────────────────────────────
  static const Color _darkSurface = Color(0xFF0B0715);
  static const Color _darkSurfaceVar = Color(0xFF160D2A);
  static const Color _darkPrimary = Color(0xFF7C3AED);
  static const Color _darkOnPrimary = Color(0xFFFFFFFF);
  static const Color _darkOnSurface = Color(0xFFE9D8FF);
  static const Color _darkSecondary = Color(0xFFA78BFA);
  static const Color _darkError = Color(0xFFF87171);

  // ── Gradients (accessible as static helpers) ───────────────────────────────
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF5B21B6), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF4C1D95), Color(0xFF312E81), Color(0xFF1E1B4B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get light {
    final base = _buildTextTheme(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: _lightOnPrimary,
        primaryContainer: Color(0xFFD8B4FE),
        onPrimaryContainer: Color(0xFF3B0764),
        secondary: _lightSecondary,
        onSecondary: _lightOnPrimary,
        secondaryContainer: Color(0xFFE9D5FF),
        onSecondaryContainer: Color(0xFF4A1272),
        tertiary: Color(0xFF0EA5E9),
        onTertiary: _lightOnPrimary,
        tertiaryContainer: Color(0xFFBAE6FD),
        onTertiaryContainer: Color(0xFF0C4A6E),
        error: _lightError,
        onError: _lightOnPrimary,
        errorContainer: Color(0xFFFECACA),
        onErrorContainer: Color(0xFF7F1D1D),
        surface: _lightSurface,
        onSurface: _lightOnSurface,
        surfaceVariant: _lightSurfaceVar,
        onSurfaceVariant: Color(0xFF4B2D79),
        outline: Color(0xFFAB8FD4),
        outlineVariant: Color(0xFFD6C4F0),
        shadow: Color(0x265B21B6),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF1A0833),
        onInverseSurface: _lightSurface,
        inversePrimary: Color(0xFFC084FC),
      ),
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: _lightOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _lightSurfaceVar,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightOnSurface,
        contentTextStyle: GoogleFonts.poppins(
          color: _lightSurface,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEDE9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Color(0xFF9B84C8),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: Color(0xFFAB8FD4),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFD6C4F0),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _lightPrimary;
          return const Color(0xFFAB8FD4);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary.withOpacity(0.25);
          }
          return const Color(0xFFD6C4F0);
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final base = _buildTextTheme(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: _darkOnPrimary,
        primaryContainer: Color(0xFF3B0764),
        onPrimaryContainer: Color(0xFFE9D5FF),
        secondary: _darkSecondary,
        onSecondary: Color(0xFF1A0A2E),
        secondaryContainer: Color(0xFF2E1065),
        onSecondaryContainer: Color(0xFFDDD6FE),
        tertiary: Color(0xFF38BDF8),
        onTertiary: Color(0xFF0C2D3F),
        tertiaryContainer: Color(0xFF0C4A6E),
        onTertiaryContainer: Color(0xFFE0F2FE),
        error: _darkError,
        onError: Color(0xFF450A0A),
        errorContainer: Color(0xFF7F1D1D),
        onErrorContainer: Color(0xFFFECACA),
        surface: _darkSurface,
        onSurface: _darkOnSurface,
        surfaceVariant: _darkSurfaceVar,
        onSurfaceVariant: Color(0xFFAB8FD4),
        outline: Color(0xFF5B3A8C),
        outlineVariant: Color(0xFF2D1A4F),
        shadow: Color(0x997C3AED),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE9D8FF),
        onInverseSurface: _darkSurface,
        inversePrimary: Color(0xFF5B21B6),
      ),
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: _darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurfaceVar,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2D1A4F),
        contentTextStyle: GoogleFonts.poppins(
          color: _darkOnSurface,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A0D30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Color(0xFF7B5EB0),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: Color(0xFF5B3A8C),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2D1A4F),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _darkPrimary;
          return const Color(0xFF5B3A8C);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary.withOpacity(0.3);
          }
          return const Color(0xFF2D1A4F);
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light
        ? const Color(0xFF1A0833)
        : const Color(0xFFE9D8FF);

    return GoogleFonts.poppinsTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
          color: baseColor,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          color: baseColor,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          color: baseColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: baseColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: baseColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: baseColor,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: baseColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: baseColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: baseColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: baseColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: baseColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: baseColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: baseColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: baseColor,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: baseColor,
        ),
      ),
    );
  }
}
