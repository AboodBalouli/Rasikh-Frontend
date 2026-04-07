import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/product_detail_page.dart';

class ItemCard extends ConsumerStatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onOpenCart;

  const ItemCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onOpenCart,
  });

  @override
  ConsumerState<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<ItemCard> {
  bool _suppressOpenDetailTap = false;
  bool isHovered = false;
  bool _incPressed = false;
  bool _decPressed = false;
  bool _addPressed = false;
  int _lastDelta = 0;

  void _markSuppressOpenDetailTap() {
    _suppressOpenDetailTap = true;
  }

  void _clearSuppressOpenDetailTapAfterTap() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _suppressOpenDetailTap = false;
    });
  }

  void _openDetailPage() {
    context.push(
      '/product-detail',
      extra: ProductDetailPageArgs(
        product: widget.product,
        isFavorite: widget.isFavorite,
        onFavoriteToggle: widget.onFavoriteToggle,
      ),
    );
  }

  /// Handle add to cart - checks for seller conflict first
  void _handleAddToCart() {
    // Get the product's seller ID
    final productSellerId = int.tryParse(widget.product.sellerId);
    
    // Get the current cart's seller ID
    final currentCartSellerId = ref.read(currentCartSellerIdProvider);
    final cartIsEmpty = ref.read(cartTotalQuantityProvider) == 0;
    
    // If cart is empty or same seller, add directly
    if (cartIsEmpty || currentCartSellerId == null || currentCartSellerId == productSellerId) {
      _addProductToCart();
      return;
    }
    
    // Cart has items from a different seller - show confirmation dialog
    _showNewCartConfirmationDialog();
  }
  
  /// Actually add the product to cart
  void _addProductToCart() {
    ref
        .read(cartControllerProvider.notifier)
        .setProductQuantityByStringId(
          productId: widget.product.id,
          quantity: 1,
        );
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
                    'بدء سلة جديدة ؟',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'عند بدء طلب جديد , ستتم ازالة المشتريات السابقة',
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
                            'الغاء',
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
                            await ref.read(cartControllerProvider.notifier).clear();
                            // Then add the new product
                            _addProductToCart();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color.fromARGB(255, 83, 125, 93),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'تأكيد البدء',
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: () {
            if (_suppressOpenDetailTap) return;
            _openDetailPage();
          },
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
                // Product Image Section
                _buildImageSection(),

                // Card Body
                _buildCardBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // Background & Image
          Container(
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
                child: _buildProductImage(widget.product.imageUrl),
              ),
            ),
          ),

          // Wishlist Button
          Positioned(
            top: 8,
            left: 8,
            child: GestureDetector(
              onTapDown: (_) => _markSuppressOpenDetailTap(),
              onTapCancel: () => _suppressOpenDetailTap = false,
              onTapUp: (_) => _clearSuppressOpenDetailTapAfterTap(),
              onTap: widget.onFavoriteToggle,
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(widget.isFavorite),
                    size: 16,
                    color: widget.isFavorite
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

  Widget _buildCardBody() {
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
                '${product.price.toInt()} دينار',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF030213),
                ),
              ),
              _buildQuantityControl(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl() {
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
          ? _buildAddToCartButton()
          : _buildCounterControl(quantity),
    );
  }

  Widget _buildAddToCartButton() {
    return AnimatedScale(
      key: const ValueKey('AddToCart'),
      duration: const Duration(milliseconds: 90),
      scale: _addPressed ? 0.92 : 1.0,
      child: GestureDetector(
        onTapDown: (_) {
          _markSuppressOpenDetailTap();
          setState(() => _addPressed = true);
        },
        onTapCancel: () {
          _suppressOpenDetailTap = false;
          setState(() => _addPressed = false);
        },
        onTapUp: (_) {
          _clearSuppressOpenDetailTapAfterTap();
          setState(() => _addPressed = false);
        },
        onTap: () {
          _handleAddToCart();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 83, 125, 93).withOpacity(0.8),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildCounterControl(int quantity) {
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
              child: GestureDetector(
                onTapDown: (_) {
                  _markSuppressOpenDetailTap();
                  setState(() => _decPressed = true);
                },
                onTapCancel: () {
                  _suppressOpenDetailTap = false;
                  setState(() => _decPressed = false);
                },
                onTapUp: (_) {
                  _clearSuppressOpenDetailTapAfterTap();
                  setState(() => _decPressed = false);
                },
                onTap: () {
                  setState(() => _lastDelta = -1);
                  ref
                      .read(cartControllerProvider.notifier)
                      .setProductQuantityByStringId(
                        productId: widget.product.id,
                        quantity: quantity - 1,
                      );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.remove, color: Colors.white, size: 14),
                ),
              ),
            ),
            const SizedBox(width: 6),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Increment button
            AnimatedScale(
              duration: const Duration(milliseconds: 90),
              scale: _incPressed ? 0.92 : 1.0,
              child: GestureDetector(
                onTapDown: (_) {
                  _markSuppressOpenDetailTap();
                  setState(() => _incPressed = true);
                },
                onTapCancel: () {
                  _suppressOpenDetailTap = false;
                  setState(() => _incPressed = false);
                },
                onTapUp: (_) {
                  _clearSuppressOpenDetailTapAfterTap();
                  setState(() => _incPressed = false);
                },
                onTap: () {
                  setState(() => _lastDelta = 1);
                  ref
                      .read(cartControllerProvider.notifier)
                      .setProductQuantityByStringId(
                        productId: widget.product.id,
                        quantity: quantity + 1,
                      );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
      );
    }

    final isAsset = trimmed.startsWith('assets/') &&
        !trimmed.contains('/images/') &&
        !trimmed.contains('images/product/');
    if (isAsset) {
      return Image.asset(trimmed, fit: BoxFit.cover);
    }

    final url = _resolveImageUrl(trimmed);
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
      ),
    );
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '${AppConfig.apiBaseUrl}$path';
    return '${AppConfig.apiBaseUrl}/$path';
  }
}
