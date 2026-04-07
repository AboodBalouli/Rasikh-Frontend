import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/markets/domain/entities/market_store.dart';
import 'package:go_router/go_router.dart';

/// Card widget for displaying a store on an event page.
/// Supports an optional "participated" badge for approved stores.
class EventStoreCard extends StatelessWidget {
  final MarketStore store;
  final bool isParticipating;

  const EventStoreCard({
    super.key,
    required this.store,
    this.isParticipating = false,
  });

  void _onVisitStore(BuildContext context) {
    context.push('/seller/${store.profileId}');
  }

  String? _buildImageUrl() {
    final url = store.profilePictureUrl;
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return '${AppConfig.apiBaseUrl}$url';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _buildImageUrl();
    final displayName = store.storeName ?? store.sellerName;
    final description = store.storeDescription ?? '';
    final rating = store.averageRating ?? 0.0;
    final ratingCount = store.ratingCount ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onVisitStore(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Store image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.lightGrey,
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          )
                        : null,
                  ),
                  child: imageUrl == null
                      ? const Icon(Icons.store, color: TColors.grey)
                      : null,
                ),
                const SizedBox(width: 14),
                // Store info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name with participation badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: TColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isParticipating) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: TColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'مشارك ✓',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: TColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: TColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      // Rating and location
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            ratingCount > 0
                                ? '${rating.toStringAsFixed(1)} ($ratingCount)'
                                : 'جديد',
                            style: const TextStyle(
                              fontSize: 12,
                              color: TColors.textSecondary,
                            ),
                          ),
                          if (store.government != null) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: TColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              store.government!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: TColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
