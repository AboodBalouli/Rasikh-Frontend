import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_product.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/product_detail_page.dart';
import 'package:go_router/go_router.dart';

/// Card widget for displaying a product on an event page.
class EventProductCard extends StatelessWidget {
  final EventProduct product;

  const EventProductCard({super.key, required this.product});

  void _onProductTap(BuildContext context) {
    final productDetail = Product(
      id: product.id.toString(),
      name: product.name,
      description: product.description ?? '',
      price: product.price ?? 0.0,
      imageUrl: _buildImageUrl() ?? '',
      sellerId: product.sellerProfileId?.toString() ?? '',
      category: product.categoryName ?? '',
    );

    context.push(
      '/product-detail',
      extra: ProductDetailPageArgs(
        product: productDetail,
        isFavorite: false,
        onFavoriteToggle: () {},
      ),
    );
  }

  String? _buildImageUrl() {
    final imageUrl = product.primaryImageUrl;
    if (imageUrl == null || imageUrl.isEmpty) return null;
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${AppConfig.apiBaseUrl}/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _buildImageUrl();
    final priceText = product.price != null
        ? '${product.price!.toStringAsFixed(2)} د.أ'
        : '';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onProductTap(context),
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            color: TColors.lightGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: TColors.lightGrey,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: TColors.lightGrey,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: TColors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: TColors.lightGrey,
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: TColors.grey,
                              size: 32,
                            ),
                          ),
                  ),
                ),
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (priceText.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        priceText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
