import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rate_store_dialog.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';
import '../../domain/entities/store_info.dart';

class StoreInfoSection extends ConsumerWidget {
  final StoreInfo info;

  const StoreInfoSection({super.key, required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerId = int.tryParse(info.sellerProfileId ?? '') ?? 0;

    // Watch store ratings to update after rating is submitted
    final ratingsAsync = ref.watch(storeRatingsProvider(sellerId));

    // Calculate rating from fetched data or use info.averageRating as fallback
    final displayRating = ratingsAsync.maybeWhen(
      data: (ratings) {
        if (ratings.isEmpty) return info.averageRating ?? 0.0;
        final sum = ratings.fold<int>(0, (acc, r) => acc + r.rating);
        return sum / ratings.length;
      },
      orElse: () => info.averageRating ?? 0.0,
    );

    final reviewCount = ratingsAsync.maybeWhen(
      data: (ratings) =>
          ratings.isNotEmpty ? ratings.length : (info.ratingCount ?? 0),
      orElse: () => info.ratingCount ?? 0,
    );

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.storeInfo,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.parastoo,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            info.storeName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.parastoo,
            ),
          ),
          const SizedBox(height: 12),

          // Rating Section with StarRatingWidget
          Row(
            children: [
              StarRatingWidget(
                rating: displayRating,
                size: 20,
                showValue: true,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showReviewsBottomSheet(context, ref, sellerId),
                child: Text(
                  '($reviewCount تقييم)',
                  style: TextStyle(
                    color: TColors.primary,
                    fontFamily: AppFonts.parastoo,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showRateDialog(context, ref, sellerId),
                icon: const Icon(
                  Icons.star_outline_rounded,
                  size: 18,
                  color: TColors.primary,
                ),
                label: const Text(
                  'قيّم',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColors.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.parastoo,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // View All Reviews Button
          OutlinedButton.icon(
            onPressed: () => _showReviewsBottomSheet(context, ref, sellerId),
            icon: const Icon(Icons.reviews_outlined, size: 18),
            label: Text('عرض جميع التقييمات ($reviewCount)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: TColors.primary,
              side: const BorderSide(color: TColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 15),
          Text(
            info.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: AppFonts.parastoo,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            AppStrings.seller,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.parastoo,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            info.sellerDescription,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: AppFonts.parastoo,
            ),
          ),
          const SizedBox(height: 20),
          // WhatsApp
          InkWell(
            onTap: () => _openWhatsApp(context, info.whatsappPhone),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: Colors.green, size: 28),
                  const SizedBox(width: 20),
                  Text(
                    AppStrings.chatOnWhatsApp,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppFonts.parastoo,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Location (tappable)
          InkWell(
            onTap: () => _openMaps(context, info),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 28),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      info.address,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: AppFonts.parastoo,
                      ),
                    ),
                  ),
                ],
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
    int sellerId,
  ) async {
    final result = await RateStoreDialog.show(
      context,
      sellerId: sellerId,
      storeName: info.storeName,
    );

    // Refresh ratings if a rating was submitted
    if (result == true) {
      ref.invalidate(storeRatingsProvider(sellerId));
    }
  }

  void _showReviewsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    int sellerId,
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
                    Text(
                      'تقييمات ${info.storeName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                        fontFamily: AppFonts.parastoo,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
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
                      storeRatingsProvider(sellerId),
                    );
                    return ratingsAsync.when(
                      data: (ratings) => ratings.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد تقييمات بعد',
                                style: TextStyle(
                                  color: TColors.textSecondary,
                                  fontFamily: AppFonts.parastoo,
                                ),
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
                                storeRatingsProvider(sellerId),
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
                      'مستخدم #${rating.userId ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: AppFonts.parastoo,
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
                '${rating.createdAt.day}/${rating.createdAt.month}/${rating.createdAt.year}',
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
                fontFamily: AppFonts.parastoo,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openMaps(BuildContext context, StoreInfo info) async {
    String query;
    if (info.latitude != null && info.longitude != null) {
      query = '${info.latitude},${info.longitude}';
    } else {
      query = Uri.encodeComponent(info.address);
    }
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح الخريطة')));
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    // Normalize phone number (remove spaces)
    final normalized = phone.replaceAll(' ', '');
    final Uri uri = Uri.parse('https://wa.me/$normalized');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح واتساب')));
    }
  }
}
