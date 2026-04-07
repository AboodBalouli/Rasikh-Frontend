import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/product_detail_page.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/season_store.dart';

class ProductItem extends StatelessWidget {
  final SeasonProduct product;
  final String storeId;

  const ProductItem({super.key, required this.product, required this.storeId});

  void _onProductTap(BuildContext context) {
    final productDetail = Product(
      id: product.id,
      name: product.name,
      description: 'this is a test description',
      price: 0.0,
      imageUrl: product.imageUrl,
      sellerId: storeId,
      category: '',
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

  @override
  Widget build(BuildContext context) {
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
              // Product Image Section with + button
              Expanded(
                child: Stack(
                  children: [
                    Container(
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
                        child: Image.network(
                          product.imageUrl,
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
                        ),
                      ),
                    ),
                  ],
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
                    const SizedBox(height: 6),
                    const Text(
                      '\$99.00',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: TColors.textPrimary,
                      ),
                    ),
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
