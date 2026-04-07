import 'package:flutter/material.dart';

class StarSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const StarSelector({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;

        return IconButton(
          iconSize: 36,
          icon: Icon(rating >= value ? Icons.star : Icons.star_border),
          onPressed: () => onChanged(value),
        );
      }),
    );
  }
}
