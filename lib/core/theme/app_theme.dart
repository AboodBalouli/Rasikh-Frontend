import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

class AppTheme {
  static OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  static final ThemeData themeData = ThemeData(
    useMaterial3: true,

    // ====== COLOR SCHEME ======
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(secondary: AppColors.secondary, error: TColors.error),

    scaffoldBackgroundColor: AppColors.background,

    // ====== TEXT THEME ======
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 34,
        letterSpacing: 0.5,
      ),
      bodySmall: TextStyle(fontSize: 14, letterSpacing: 0.5),
    ),

    // ====== INPUT FIELDS ======
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      errorStyle: const TextStyle(fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      border: _outlineBorder(TColors.borderSecondary),
      enabledBorder: _outlineBorder(TColors.borderSecondary),
      focusedBorder: _outlineBorder(AppColors.primary),
      errorBorder: _outlineBorder(TColors.error),
      focusedErrorBorder: _outlineBorder(TColors.error),
      labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    ),

    // ====== TEXT BUTTONS ======
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.all(4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // ====== OUTLINED BUTTONS ======
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: Colors.grey.shade300),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    // ====== ELEVATED BUTTONS ======
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),

    // ====== FILLED BUTTONS ======
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: Colors.grey.shade300,
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),

    // ====== APP BAR ======
    appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, elevation: 0),
  );

  // OPTIONAL STANDALONE TEXT STYLES
  static const TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 34,
    letterSpacing: 0.5,
  );

  static const TextStyle bodySmall = TextStyle(
    color: Colors.grey,
    letterSpacing: 0.5,
  );
}
