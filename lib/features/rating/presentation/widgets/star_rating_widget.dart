import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

/// A read-only star rating display widget.
///
/// Shows filled, half-filled, or empty stars based on the rating value.
class StarRatingWidget extends StatelessWidget {
  /// The rating value (0.0 to 5.0).
  final double rating;

  /// The size of each star icon.
  final double size;

  /// The color of filled stars.
  final Color? activeColor;

  /// The color of empty stars.
  final Color? inactiveColor;

  /// Whether to show the numeric rating next to the stars.
  final bool showValue;

  /// Text style for the rating value.
  final TextStyle? valueTextStyle;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
    this.showValue = false,
    this.valueTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final filledColor = activeColor ?? TColors.gold;
    final emptyColor = inactiveColor ?? TColors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          IconData icon;
          Color color;

          if (rating >= starValue) {
            // Full star
            icon = Icons.star_rounded;
            color = filledColor;
          } else if (rating >= starValue - 0.5) {
            // Half star
            icon = Icons.star_half_rounded;
            color = filledColor;
          } else {
            // Empty star
            icon = Icons.star_border_rounded;
            color = emptyColor;
          }

          return Icon(icon, size: size, color: color);
        }),
        if (showValue) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style:
                valueTextStyle ??
                TextStyle(
                  fontSize: size * 0.7,
                  fontWeight: FontWeight.w600,
                  color: TColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
