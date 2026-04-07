import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rating_list_widget.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:go_router/go_router.dart';

/// A page that displays all ratings for a product.
class ProductRatingsPage extends ConsumerWidget {
  final int productId;
  final String productName;
  final double currentRating;
  final int reviewCount;

  const ProductRatingsPage({
    super.key,
    required this.productId,
    required this.productName,
    this.currentRating = 0.0,
    this.reviewCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingsAsync = ref.watch(productRatingsProvider(productId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: TColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'التقييمات',
          style: const TextStyle(
            color: TColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with product name and overall rating
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                StarRatingWidget(
                  rating: currentRating,
                  size: 28,
                  showValue: true,
                  valueTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$reviewCount ${reviewCount == 1 ? 'تقييم' : 'تقييمات'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: TColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Ratings list
          Expanded(
            child: ratingsAsync.when(
              data: (ratings) => RatingListWidget(
                productRatings: ratings,
                emptyMessage: 'لا توجد تقييمات بعد',
              ),
              loading: () => const RatingListWidget(isLoading: true),
              error: (error, _) => RatingListWidget(
                errorMessage: error.toString(),
                onRetry: () =>
                    ref.invalidate(productRatingsProvider(productId)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
