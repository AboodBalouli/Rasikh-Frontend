import 'package:flutter/material.dart';

/// Responsive utility class for building adaptive UIs.
///
/// Usage:
/// ```dart
/// // Get responsive width (10% of screen width)
/// Responsive.wp(context, 10)
///
/// // Get responsive height (5% of screen height)
/// Responsive.hp(context, 5)
///
/// // Get responsive font size
/// Responsive.sp(context, 16)
///
/// // Get responsive padding
/// Responsive.padding(context)
/// ```
class Responsive {
  // Screen size breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  /// Returns screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Returns width as percentage of screen width
  /// [percent] should be between 0 and 100
  static double wp(BuildContext context, double percent) =>
      screenWidth(context) * (percent / 100);

  /// Returns height as percentage of screen height
  /// [percent] should be between 0 and 100
  static double hp(BuildContext context, double percent) =>
      screenHeight(context) * (percent / 100);

  /// Returns a scaled font size based on screen width
  /// Base is calculated from a 375px wide design (iPhone SE)
  static double sp(BuildContext context, double size) {
    final width = screenWidth(context);
    final scaleFactor = width / 375;
    // Clamp scale factor to prevent too small/large text
    final clampedScale = scaleFactor.clamp(0.8, 1.3);
    return size * clampedScale;
  }

  /// Returns whether current screen is mobile-sized
  static bool isMobile(BuildContext context) =>
      screenWidth(context) < tabletBreakpoint;

  /// Returns whether current screen is tablet-sized
  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= tabletBreakpoint &&
      screenWidth(context) < desktopBreakpoint;

  /// Returns whether current screen is desktop-sized
  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= desktopBreakpoint;

  /// Returns responsive horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Returns responsive vertical padding based on screen size
  static double verticalPadding(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  /// Returns symmetric EdgeInsets that adapts to screen size
  static EdgeInsets padding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: horizontalPadding(context),
    vertical: verticalPadding(context),
  );

  /// Returns horizontal-only EdgeInsets
  static EdgeInsets paddingH(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: horizontalPadding(context));

  /// Returns vertical-only EdgeInsets
  static EdgeInsets paddingV(BuildContext context) =>
      EdgeInsets.symmetric(vertical: verticalPadding(context));

  /// Returns all-sides EdgeInsets with responsive value
  static EdgeInsets paddingAll(BuildContext context, {double factor = 1.0}) =>
      EdgeInsets.all(horizontalPadding(context) * factor);

  /// Returns responsive spacing for SizedBox height
  static double verticalSpacing(BuildContext context, {double factor = 1.0}) =>
      hp(context, 2) * factor;

  /// Returns responsive spacing for SizedBox width
  static double horizontalSpacing(
    BuildContext context, {
    double factor = 1.0,
  }) => wp(context, 2) * factor;

  /// Returns a value based on screen size breakpoint
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}

/// Extension on BuildContext for easier access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Screen width
  double get screenWidth => Responsive.screenWidth(this);

  /// Screen height
  double get screenHeight => Responsive.screenHeight(this);

  /// Width percentage
  double wp(double percent) => Responsive.wp(this, percent);

  /// Height percentage
  double hp(double percent) => Responsive.hp(this, percent);

  /// Scalable font size
  double sp(double size) => Responsive.sp(this, size);

  /// Is mobile screen
  bool get isMobile => Responsive.isMobile(this);

  /// Is tablet screen
  bool get isTablet => Responsive.isTablet(this);

  /// Is desktop screen
  bool get isDesktop => Responsive.isDesktop(this);

  /// Responsive padding
  EdgeInsets get responsivePadding => Responsive.padding(this);
}
