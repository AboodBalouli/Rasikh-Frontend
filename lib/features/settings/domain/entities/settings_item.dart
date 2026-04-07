class SettingsItem {
  final String title;
  final String description;

  /// Mirrors [IconData.codePoint] so domain stays Flutter-free.
  final int iconCodePoint;

  /// Mirrors [IconData.fontFamily].
  final String? iconFontFamily;

  /// Mirrors [IconData.fontPackage].
  final String? iconFontPackage;

  /// Mirrors [IconData.matchTextDirection].
  final bool iconMatchTextDirection;

  /// ARGB color value, e.g. `Colors.blue.value`.
  final int? colorValue;

  const SettingsItem({
    required this.title,
    required this.description,
    required this.iconCodePoint,
    this.iconFontFamily,
    this.iconFontPackage,
    this.iconMatchTextDirection = false,
    this.colorValue,
  });
}
