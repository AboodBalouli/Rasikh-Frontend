import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rating_list_widget.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:go_router/go_router.dart';

/// A page that displays all ratings for a store/seller.
class StoreRatingsPage extends ConsumerWidget {
  final int sellerId;
  final String storeName;
  final double currentRating;
  final int reviewCount;

  const StoreRatingsPage({
    super.key,
    required this.sellerId,
    required this.storeName,
    this.currentRating = 0.0,
    this.reviewCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingsAsync = ref.watch(storeRatingsProvider(sellerId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: TColors.textPrimary,
            ),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'تقييمات المتجر',
            style: TextStyle(
              color: TColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Header with store name and overall rating
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
                    storeName,
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
                  storeRatings: ratings,
                  emptyMessage: 'لا توجد تقييمات بعد',
                ),
                loading: () => const RatingListWidget(isLoading: true),
                error: (error, _) => RatingListWidget(
                  errorMessage: error.toString(),
                  onRetry: () => ref.invalidate(storeRatingsProvider(sellerId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
