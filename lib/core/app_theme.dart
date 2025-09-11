import 'package:flutter/material.dart';
import '../base/extensions/utils/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    const Color primary = Color(0xFF009688); // teal
    const Color primaryDark = Color(0xFF00796B);

    final ColorScheme colorScheme = const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryDark,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      background: Color(0xFFF6F7FB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
    );

    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: primary,
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary),
        ),
        labelStyle: const TextStyle(color: AppColors.inputLabelColor),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFF6EDF7), // subtle lilac like screenshot
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(),
      ),
    );
  }
}


