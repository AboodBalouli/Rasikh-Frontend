import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller_provider.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

/// A reusable product card widget for organization details page.
/// Displays product image, name, price, and add to cart button.
/// Connected to cart and wishlist backends with debounced updates.
class OrganizationProductCard extends ConsumerStatefulWidget {
  const OrganizationProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onTap,
    this.imageAspectRatio = 1.6,
    this.onWishlistToggle,
  });

  /// The product to display
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final double imageAspectRatio;
  final VoidCallback? onWishlistToggle;

  @override
  ConsumerState<OrganizationProductCard> createState() =>
      _OrganizationProductCardState();
}

class _OrganizationProductCardState
    extends ConsumerState<OrganizationProductCard> {
  // State Variables
  bool isHovered = false;
  bool _incPressed = false;
  bool _decPressed = false;
  bool _addPressed = false;
  int _lastDelta = 0;
  bool _isTogglingWishlist = false;

  /// Handle initial add to cart - checks for seller conflict first
  void _handleAddToCart() {
    // Get the product's seller ID
    final productSellerId = int.tryParse(widget.product.sellerId);

    // Get the current cart's seller ID
    final currentCartSellerId = ref.read(currentCartSellerIdProvider);
    final cartIsEmpty = ref.read(cartTotalQuantityProvider) == 0;

    // If cart is empty or same seller, add directly
    if (cartIsEmpty ||
        currentCartSellerId == null ||
        currentCartSellerId == productSellerId) {
      _addProductToCart();
      return;
    }

    // Cart has items from a different seller - show confirmation dialog
    _showNewCartConfirmationDialog();
  }

  /// Actually add the product to cart
  void _addProductToCart() {
    _syncQuantityToCart(1);
    widget.onAddToCart?.call();
  }

  /// Show confirmation dialog when switching to a new store
  void _showNewCartConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 48,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.startNewCart,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.startNewCartMessage,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => dialogContext.pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppStrings.cancel,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            dialogContext.pop();
                            // Clear the cart first
                            await ref
                                .read(cartControllerProvider.notifier)
                                .clear();
                            // Then add the new product
                            _addProductToCart();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color.fromARGB(
                              255,
                              83,
                              125,
                              93,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppStrings.confirmStart,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Increment quantity and sync to cart with debounce
  void _handleIncrement() {
    final currentQty = ref.read(
      cartQuantityForProductIdProvider(widget.product.id),
    );
    setState(() {
      _lastDelta = 1;
    });
    _syncQuantityToCart(currentQty + 1);
  }

  /// Decrement quantity - minimum is 0 (removes from cart)
  void _handleDecrement() {
    final currentQty = ref.read(
      cartQuantityForProductIdProvider(widget.product.id),
    );
    if (currentQty > 0) {
      setState(() {
        _lastDelta = -1;
      });
      _syncQuantityToCart(currentQty - 1);
    }
  }

  /// Sync the current quantity to the cart backend with debounce
  void _syncQuantityToCart(int newQuantity) {
    if (widget.product.id.isEmpty) return;

    ref
        .read(cartControllerProvider.notifier)
        .setProductQuantityByStringId(
          productId: widget.product.id,
          quantity: newQuantity,
        );
  }

  /// Toggle wishlist state using the wishlist controller
  Future<void> _toggleFavorite() async {
    if (_isTogglingWishlist) return;

    setState(() {
      _isTogglingWishlist = true;
    });

    try {
      await ref
          .read(wishlistControllerProvider.notifier)
          .toggle(widget.product);
      widget.onWishlistToggle?.call();
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                AppStrings.failedToUpdateWishlist,
                style: GoogleFonts.cairo(),
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingWishlist = false;
        });
      }
    }
  }

  /// Check if product is in wishlist
  bool get _isFavorite {
    return ref
        .watch(wishlistControllerProvider)
        .items
        .any((p) => p.id == widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = _isFavorite;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.15 : 0.05),
              blurRadius: isHovered ? 12 : 4,
              offset: Offset(0, isHovered ? 6 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image Section (Top)
            _buildImageSection(isFavorite),

            // Card Body (Bottom)
            _buildCardBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isFavorite) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // Background & Image - Tappable area
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AnimatedScale(
                  scale: isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: widget.product.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
          ),

          // Wishlist Button
          Positioned(
            top: 8,
            left: 8,
            child: InkWell(
              onTap: _toggleFavorite,
              customBorder: const CircleBorder(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _isTogglingWishlist
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF6B7280),
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFavorite),
                          size: 16,
                          color: isFavorite
                              ? const Color(0xFFF43F5E) // Rose
                              : const Color(0xFF6B7280), // Gray
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Name
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 8),

          // Description
          if (product.description.isNotEmpty)
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),

          if (product.description.isNotEmpty) const SizedBox(height: 6),

          // Rating Row
          Row(
            children: [
              const Icon(Icons.star, size: 12, color: Color(0xFFFFB300)),
              const SizedBox(width: 6),
              Text(
                product.rating.toStringAsFixed(1),
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Price + Counter in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product.price.toInt()} ${AppStrings.currency}',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF030213),
                ),
              ),
              Builder(
                builder: (context) {
                  final quantity = ref.watch(
                    cartQuantityForProductIdProvider(widget.product.id),
                  );
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      );
                    },
                    child: quantity == 0
                        ? _buildAddToCartButton(context)
                        : _buildCounterControl(quantity, context),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return AnimatedScale(
      key: const ValueKey('AddToCart'),
      duration: const Duration(milliseconds: 90),
      scale: _addPressed ? 0.92 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _handleAddToCart,
          onTapDown: (_) => setState(() => _addPressed = true),
          onTapCancel: () => setState(() => _addPressed = false),
          onTapUp: (_) => setState(() => _addPressed = false),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 83, 125, 93).withOpacity(0.8),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.add, color: Colors.white, size: context.sp(18)),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterControl(int quantity, BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        key: const ValueKey('Counter'),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 83, 125, 93).withOpacity(0.8),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement button
            AnimatedScale(
              duration: const Duration(milliseconds: 90),
              scale: _decPressed ? 0.92 : 1.0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _handleDecrement,
                  onTapDown: (_) => setState(() => _decPressed = true),
                  onTapCancel: () => setState(() => _decPressed = false),
                  onTapUp: (_) => setState(() => _decPressed = false),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: context.sp(14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.wp(1.5)),
            // Quantity display
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 20),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    );
                    final beginOffset = Offset(
                      0,
                      _lastDelta > 0 ? 0.25 : -0.25,
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: beginOffset,
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    quantity.toString(),
                    key: ValueKey<int>(quantity),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: context.sp(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.wp(1.5)),
            // Increment button
            AnimatedScale(
              duration: const Duration(milliseconds: 90),
              scale: _incPressed ? 0.92 : 1.0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _handleIncrement,
                  onTapDown: (_) => setState(() => _incPressed = true),
                  onTapCancel: () => setState(() => _incPressed = false),
                  onTapUp: (_) => setState(() => _incPressed = false),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: context.sp(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
