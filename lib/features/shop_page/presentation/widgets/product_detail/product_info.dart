import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rate_product_dialog.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';

class ProductInfo extends ConsumerWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productIdInt = int.tryParse(product.id) ?? 0;

    // Watch ratings to update when new rating is submitted
    final ratingsAsync = ref.watch(productRatingsProvider(productIdInt));

    // Calculate rating from fetched data or use product.rating as fallback
    final displayRating = ratingsAsync.maybeWhen(
      data: (ratings) {
        if (ratings.isEmpty) return product.rating;
        final sum = ratings.fold<int>(0, (acc, r) => acc + r.rating);
        return sum / ratings.length;
      },
      orElse: () => product.rating,
    );

    final reviewCount = ratingsAsync.maybeWhen(
      data: (ratings) => ratings.length,
      orElse: () => product.reviewCount,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.wp(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title and Price Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: context.sp(28),
                    color: const Color.fromARGB(255, 83, 148, 93),
                    fontWeight: FontWeight.w900,
                    fontFamily: AppFonts.parastoo,
                  ),
                ),
              ),
              SizedBox(width: context.wp(3)),
              Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: context.sp(26),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFE3A428),
                  fontFamily: AppFonts.parastoo,
                ),
              ),
            ],
          ),

          SizedBox(height: context.hp(1.5)),

          // 2. Rating Row with StarRatingWidget
          Row(
            children: [
              StarRatingWidget(
                rating: displayRating,
                size: context.sp(20),
                showValue: true,
              ),
              SizedBox(width: context.wp(2)),
              GestureDetector(
                onTap: () =>
                    _showReviewsBottomSheet(context, ref, productIdInt),
                child: Text(
                  "($reviewCount تقييم)",
                  style: TextStyle(
                    color: TColors.primary,
                    fontSize: context.sp(14),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              // Rate button
              TextButton.icon(
                onPressed: () => _showRateDialog(context, ref, productIdInt),
                icon: Icon(
                  Icons.star_outline_rounded,
                  size: context.sp(18),
                  color: TColors.primary,
                ),
                label: Text(
                  'قيّم',
                  style: TextStyle(
                    fontSize: context.sp(14),
                    color: TColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.wp(3),
                    vertical: context.hp(0.5),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.hp(2.5)),

          // 3. Description
          Text(
            product.description,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.7,
              fontSize: context.sp(15),
              fontFamily: AppFonts.parastoo,
            ),
          ),

          SizedBox(height: context.hp(2)),

          // 4. View All Reviews Button
          OutlinedButton.icon(
            onPressed: () =>
                _showReviewsBottomSheet(context, ref, productIdInt),
            icon: const Icon(Icons.reviews_outlined),
            label: Text('عرض جميع التقييمات ($reviewCount)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: TColors.primary,
              side: const BorderSide(color: TColors.primary),
              padding: EdgeInsets.symmetric(
                horizontal: context.wp(4),
                vertical: context.hp(1.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRateDialog(
    BuildContext context,
    WidgetRef ref,
    int productIdInt,
  ) async {
    final result = await RateProductDialog.show(
      context,
      productId: productIdInt,
      productName: product.name,
    );

    // Refresh ratings if a rating was submitted
    if (result == true) {
      ref.invalidate(productRatingsProvider(productIdInt));
    }
  }

  void _showReviewsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    int productIdInt,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      'التقييمات والتعليقات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Ratings list
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final ratingsAsync = ref.watch(
                      productRatingsProvider(productIdInt),
                    );
                    return ratingsAsync.when(
                      data: (ratings) => ratings.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد تقييمات بعد',
                                style: TextStyle(color: TColors.textSecondary),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: ratings.length,
                              itemBuilder: (context, index) {
                                final rating = ratings[index];
                                return _buildReviewItem(context, rating);
                              },
                            ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: TColors.error,
                            ),
                            const SizedBox(height: 8),
                            Text(e.toString()),
                            TextButton(
                              onPressed: () => ref.invalidate(
                                productRatingsProvider(productIdInt),
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, dynamic rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: TColors.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مستخدم #${rating.userId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    StarRatingWidget(
                      rating: rating.rating.toDouble(),
                      size: 14,
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(rating.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              rating.comment!,
              style: const TextStyle(
                fontSize: 14,
                color: TColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
