import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/made_with_love.dart';
import '../../../wishlists/presentation/pages/wishlist_page.dart';

class HeaderSection extends ConsumerWidget {
  final List<Product> wishlist;
  final Map<Product, int> cartItems;
  final Function(Product) onRemoveFromWishlist;
  final Function(Product) onAddToCartFromWishlist;
  final Function(Product) onRemoveFromCart;
  final Function(Product) onToggleWishlist;
  final Function(Product) onAddToCart;
  final Function(Product) onDeleteFromCart;
  final Function(Product, int) onUpdateQuantity;

  const HeaderSection({
    super.key,
    required this.wishlist,
    required this.cartItems,
    required this.onRemoveFromWishlist,
    required this.onAddToCartFromWishlist,
    required this.onRemoveFromCart,
    required this.onToggleWishlist,
    required this.onAddToCart,
    required this.onDeleteFromCart,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartTotalQuantityProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                height: 190,
                color: Colors.white.withValues(alpha: 0.6),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const MadeWithLove(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(),
                        _icon(
                          icon: Icons.person_outline,
                          onTap: () => context.push('/profile'),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _icon(
                          icon: Icons.favorite_border,
                          badge: wishlist.length,
                          onTap: () {
                            context.push(
                              '/wishlist',
                              extra: WishlistRouteArgs(
                                wishlist: wishlist,
                                onRemove: onRemoveFromWishlist,
                                onAddToCart: onAddToCartFromWishlist,
                                onRemoveFromCart: onRemoveFromCart,
                                onDeleteFromCart: onDeleteFromCart,
                                cartItems: cartItems,
                                onToggleWishlist: onToggleWishlist,
                                onUpdateQuantity: onUpdateQuantity,
                              ),
                            );
                          },
                        ),
                        _icon(
                          icon: Icons.shopping_cart_outlined,
                          badge: cartCount,
                          onTap: () {
                            context.push('/cart');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon({
    required IconData icon,
    int badge = 0,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            child: Icon(icon, color: Colors.black87),
          ),
          if (badge > 0)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
