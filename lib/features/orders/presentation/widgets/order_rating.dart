import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class OrderRating extends StatelessWidget {
  final int rating; // 0 = not rated
  final VoidCallback onTap;

  const OrderRating({super.key, required this.rating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            final value = index + 1;

            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                rating >= value ? Icons.star : Icons.star_border,
                size: context.sp(24),
              ),
              onPressed: rating == 0 ? onTap : null,
            );
          }),
        ),
        if (rating > 0)
          Text(
            'تقييمك للطلب: $rating / 5 ⭐',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: context.sp(12)),
          ),
      ],
    );
  }
}
