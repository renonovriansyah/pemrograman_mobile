import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama dari Logo
  static const Color primaryRed = Color(0xFF720E1E); // Merah Marun
  static const Color accentGold = Color(0xFFFFCD05); // Kuning Emas
  static const Color fireOrange = Color(0xFFF47920); // Oranye Api
  
  // Warna UI
  static const Color background = Color(0xFFF9F9F9); // Putih agak abu dikit biar mata gak sakit
  static const Color cardSurface = Colors.white;
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Colors.white;
  
  // Warna Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
}

// Tema Global
ThemeData sizzleTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryRed,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryRed,
      secondary: AppColors.accentGold,
      surface: AppColors.cardSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.textLight,
      centerTitle: true,
      elevation: 0,
    ),
    // Style Tombol Default (Rounded & Bold)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}