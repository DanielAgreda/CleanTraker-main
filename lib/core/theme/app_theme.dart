import 'package:flutter/material.dart';

class AppTheme {
  // Paleta exacta extraída del diseño CleanTracker
  static const Color mintBackground = Color(0xFFDDF7F6);
  static const Color creamHighlight = Color(0xFFF6F6D5);
  static const Color forestDark = Color(0xFF183635);
  static const Color forestMuted = Color(0xFF4A6B69);
  static const Color buttonMintDisabled = Color(0xFFD9F3F1);
  static const Color surfaceWhite = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forestDark,
        primary: forestDark,
        secondary: forestMuted,
        surface: surfaceWhite,
      ),
      scaffoldBackgroundColor: surfaceWhite,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          color: forestDark,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          color: forestDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: forestDark, width: 1.8),
        ),
      ),
    );
  }
}
