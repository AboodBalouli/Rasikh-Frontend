import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:intl/intl.dart';

/// A widget that displays a list of ratings (product or store).
class RatingListWidget extends StatelessWidget {
  /// List of product ratings to display.
  final List<ProductRating>? productRatings;

  /// List of store ratings to display.
  final List<StoreRating>? storeRatings;

  /// Whether the list is currently loading.
  final bool isLoading;

  /// Error message to display if any.
  final String? errorMessage;

  /// Callback when retry is tapped on error state.
  final VoidCallback? onRetry;

  /// Empty state message.
  final String emptyMessage;

  const RatingListWidget({
    super.key,
    this.productRatings,
    this.storeRatings,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.emptyMessage = 'No ratings yet',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: TColors.error,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                TextButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      );
    }

    final items = _buildItems();

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_border_rounded,
                size: 64,
                color: TColors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => items[index],
    );
  }

  List<Widget> _buildItems() {
    if (productRatings != null) {
      return productRatings!.map(_buildProductRatingItem).toList();
    }
    if (storeRatings != null) {
      return storeRatings!.map(_buildStoreRatingItem).toList();
    }
    return [];
  }

  Widget _buildProductRatingItem(ProductRating rating) {
    return _RatingItemTile(
      rating: rating.rating,
      comment: rating.comment,
      createdAt: rating.createdAt,
      userId: rating.userId,
    );
  }

  Widget _buildStoreRatingItem(StoreRating rating) {
    return _RatingItemTile(
      rating: rating.rating,
      comment: rating.comment,
      createdAt: rating.createdAt,
      userId: rating.userId,
    );
  }
}

class _RatingItemTile extends StatelessWidget {
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final int? userId;

  const _RatingItemTile({
    required this.rating,
    this.comment,
    required this.createdAt,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User avatar placeholder
              CircleAvatar(
                radius: 18,
                backgroundColor: TColors.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.person_rounded,
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
                      userId != null ? 'User #$userId' : 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: TColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    StarRatingWidget(rating: rating.toDouble(), size: 16),
                  ],
                ),
              ),
              Text(
                dateFormat.format(createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: TColors.textSecondary,
                ),
              ),
            ],
          ),
          if (comment != null && comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              comment!,
              style: const TextStyle(
                fontSize: 14,
                color: TColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
