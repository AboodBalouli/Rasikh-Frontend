import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import '../../../shop_page/presentation/pages/product_detail_page.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Map<Product, int> cartItems;
  final Function(Product) onToggleWishlist;
  final VoidCallback onOpenCart;
  final Function(Product, int) onUpdateQuantity;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.cartItems,
    required this.onToggleWishlist,
    required this.onOpenCart,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissibleBackground(),
      onDismissed: (_) => onRemove(),
      child: GestureDetector(
        onTap: () => _showProductDetails(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildProductImage(product.imageUrl),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: AppFonts.parastoo,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          color: Color(0xFF53945D),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                Material(
                  color: const Color(0xFFF1F8F2),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showProductDetails(context),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Color(0xFF53945D),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      return const Icon(Icons.image, color: Colors.grey);
    }

    if (trimmed.startsWith('assets/') &&
        !trimmed.contains('/images/') &&
        !trimmed.contains('images/product/')) {
      return Image.asset(trimmed, fit: BoxFit.contain);
    }

    final url = _resolveImageUrl(trimmed);
    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.grey),
    );
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '${AppConfig.apiBaseUrl}$path';
    return '${AppConfig.apiBaseUrl}/$path';
  }

  Widget _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent.shade100.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 25),
      child: const Icon(
        Icons.delete_sweep_outlined,
        color: Colors.red,
        size: 30,
      ),
    );
  }

  void _showProductDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ProductDetailPage(
              product: product,
              isFavorite: true,
              onFavoriteToggle: () => onToggleWishlist(product),
              scrollController: scrollController,
            ),
          );
        },
      ),
    );
  }
}
