import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

/// An interactive star rating input widget.
///
/// Users can tap or drag to select a rating from 1 to 5.
class RatingInputWidget extends StatefulWidget {
  /// Initial rating value (1-5, or 0 for no selection).
  final int initialRating;

  /// Callback when rating changes.
  final ValueChanged<int>? onRatingChanged;

  /// The size of each star icon.
  final double size;

  /// The color of selected stars.
  final Color? activeColor;

  /// The color of unselected stars.
  final Color? inactiveColor;

  /// Whether the widget is enabled for interaction.
  final bool enabled;

  const RatingInputWidget({
    super.key,
    this.initialRating = 0,
    this.onRatingChanged,
    this.size = 40,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  State<RatingInputWidget> createState() => _RatingInputWidgetState();
}

class _RatingInputWidgetState extends State<RatingInputWidget> {
  late int _currentRating;
  int _hoverRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  void didUpdateWidget(RatingInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating;
    }
  }

  void _updateRating(int rating) {
    if (!widget.enabled) return;
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged?.call(rating);
  }

  int _getRatingFromPosition(Offset localPosition) {
    final starWidth = widget.size + 8; // size + padding
    final rating = (localPosition.dx / starWidth).ceil().clamp(1, 5);
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    final filledColor = widget.activeColor ?? TColors.gold;
    final emptyColor = widget.inactiveColor ?? TColors.grey;

    return GestureDetector(
      onHorizontalDragUpdate: widget.enabled
          ? (details) {
              final rating = _getRatingFromPosition(details.localPosition);
              setState(() {
                _hoverRating = rating;
              });
            }
          : null,
      onHorizontalDragEnd: widget.enabled
          ? (details) {
              if (_hoverRating > 0) {
                _updateRating(_hoverRating);
              }
              setState(() {
                _hoverRating = 0;
              });
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          final displayRating = _hoverRating > 0
              ? _hoverRating
              : _currentRating;
          final isFilled = displayRating >= starValue;

          return GestureDetector(
            onTap: widget.enabled ? () => _updateRating(starValue) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedScale(
                scale: isFilled ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  size: widget.size,
                  color: isFilled ? filledColor : emptyColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
