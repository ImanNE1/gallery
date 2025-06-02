// lib/utils/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart'; // Pastikan path ini benar

class AppTheme {
  static ThemeData get luxuriousDarkTheme {
    // Pastikan font 'Montserrat' sudah benar dikonfigurasi di pubspec.yaml
    // dan file fontnya ada di assets/fonts/
    const String appFontFamily = 'Montserrat';

    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.accentColor,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        cardColor: AppColors.cardBackground,
        hintColor: AppColors.accentColor,
        fontFamily: appFontFamily,
        textTheme: const TextTheme(
          // Pastikan setiap TextStyle ini didefinisikan dengan benar
          displayLarge: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: AppColors.headlineText,
              letterSpacing: 1.2,
              fontFamily: appFontFamily),
          titleMedium: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: AppColors.headlineText,
              fontFamily: appFontFamily),
          bodyLarge: TextStyle(
              fontSize: 16.0,
              color: AppColors.bodyText,
              height: 1.5, // Tinggi baris untuk keterbacaan
              fontFamily: appFontFamily),
          bodyMedium: TextStyle(
              fontSize: 14.0,
              color: AppColors
                  .bodyText, // Opacity dihilangkan dari definisi dasar agar lebih aman
              fontFamily: appFontFamily),
          labelLarge: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.headlineText,
              fontFamily: appFontFamily),
        ),
        appBarTheme: const AppBarTheme(
          color: AppColors.cardBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.iconColor),
          // Pastikan titleTextStyle ini didefinisikan dengan benar
          titleTextStyle: TextStyle(
            color: AppColors.headlineText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: appFontFamily,
          ),
          actionsIconTheme: IconThemeData(
              color: AppColors.iconColor), // Menambahkan ini untuk konsistensi
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.headlineText,
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: AppColors.headlineText,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: appFontFamily),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 6.0,
          shadowColor: AppColors.subtleShadow,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: AppColors.cardBackground,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.iconColor,
          size: 24.0,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.accentColor,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          titleTextStyle: const TextStyle(
              color: AppColors.headlineText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: appFontFamily),
          contentTextStyle: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 16,
              fontFamily: appFontFamily),
        ),
        snackBarTheme: SnackBarThemeData(
          // Menambahkan SnackBar theme
          backgroundColor: AppColors.cardBackground,
          contentTextStyle: const TextStyle(
              color: AppColors.headlineText, fontFamily: appFontFamily),
          actionTextColor: AppColors.accentColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 6.0,
        ));
  }
}
