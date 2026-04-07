import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

class AppColors {
  const AppColors._();

  // Keep a single source-of-truth palette across the app.
  // These map to the existing TColors so widgets and ThemeData stay consistent.
  static const Color primary = TColors.primary;
  static const Color secondary = TColors.accent;
  static const Color background = TColors.light;
  static const Color surface = TColors.white;
  static const Color card = TColors.white;
}
