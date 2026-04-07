import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/products/presentation/providers/product_details_providers.dart';
import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_application_1/features/shop_page/presentation/widgets/product_detail/product_bottom_bar.dart';

/// Product Details Screen - displays complete product information
/// with ability to add to cart and toggle wishlist.
///
/// Follows RTL (Arabic) layout with Cairo font.
class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.associationName,
    this.associationId,
  });

  /// The product to display.
  final Product product;

  /// Initial favorite state.
  final bool isFavorite;

  /// Callback when favorite is toggled.
  final VoidCallback? onFavoriteToggle;

  /// The name of the association/organization selling this product.
  final String? associationName;

  /// The ID of the association/organization for navigation.
  final String? associationId;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _favoriteAnimationController;
  late Animation<double> _favoriteScaleAnimation;
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize favorite animation
    _favoriteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _favoriteAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize controller with product data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productDetailsControllerProvider.notifier)
          .initWithProduct(widget.product, isFavorite: widget.isFavorite);
    });
  }

  @override
  void dispose() {
    _favoriteAnimationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    // Play animation
    await _favoriteAnimationController.forward();
    await _favoriteAnimationController.reverse();

    // Toggle favorite using unified wishlistControllerProvider
    await ref.read(wishlistControllerProvider.notifier).toggle(widget.product);

    widget.onFavoriteToggle?.call();
  }

  void _navigateBack() {
    context.pop();
  }

  void _navigateToAssociation() {
    if (widget.associationId != null) {
      context.pop();
    }
  }

  void _handleAddToCart() {
    // Just close the page (same as normal store behavior)
    context.pop();
  }

  void _handleIncrement() {
    final quantity = ref.read(
      cartQuantityForProductIdProvider(widget.product.id),
    );
    ref
        .read(cartControllerProvider.notifier)
        .setProductQuantityByStringId(
          productId: widget.product.id,
          quantity: quantity + 1,
        );
  }

  void _handleDecrement() {
    final quantity = ref.read(
      cartQuantityForProductIdProvider(widget.product.id),
    );
    final next = quantity > 0 ? quantity - 1 : 0;
    ref
        .read(cartControllerProvider.notifier)
        .setProductQuantityByStringId(
          productId: widget.product.id,
          quantity: next,
        );
  }

  /// Resolves the image URL, prepending the API base URL if needed.
  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmed = path.trim();
    if (trimmed.startsWith('http')) return trimmed;
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  @override
  Widget build(BuildContext context) {
    // Read quantity directly from cart (same as normal store)
    final quantity = ref.watch(
      cartQuantityForProductIdProvider(widget.product.id),
    );
    // Read favorite state from unified wishlistControllerProvider
    final isFavorite = ref
        .watch(wishlistControllerProvider)
        .items
        .any((p) => p.id == widget.product.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              // Scrollable content
              CustomScrollView(
                slivers: [
                  // Product image section
                  SliverToBoxAdapter(child: _buildImageSection(isFavorite)),
                  // Product details content
                  SliverToBoxAdapter(child: _buildDetailsContent()),
                  // Bottom padding for fixed bottom bar
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              // Fixed bottom action bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomActionBar(quantity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the product image section with overlay buttons using carousel.
  Widget _buildImageSection(bool isFavorite) {
    // Get all images - use allImageUrls which handles backwards compatibility
    final imageUrls = widget.product.allImageUrls;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Product Image Carousel
          AspectRatio(
            aspectRatio: 1,
            child: imageUrls.isNotEmpty
                ? _ProductImageCarouselInline(
                    imageUrls: imageUrls,
                    resolveUrl: _resolveImageUrl,
                  )
                : _buildPlaceholderImage(),
          ),
          // Overlay buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wishlist button (left in RTL)
                _buildOverlayButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: isFavorite
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF374151),
                  onTap: _toggleFavorite,
                  scale: _favoriteScaleAnimation,
                ),
                // Back button (right in RTL)
                _buildOverlayButton(
                  icon: Icons.arrow_forward_ios,
                  iconColor: Colors.black,
                  onTap: _navigateBack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildOverlayButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    Animation<double>? scale,
  }) {
    Widget button = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Center(child: Icon(icon, size: 20, color: iconColor)),
            ),
          ),
        ),
      ),
    );

    if (scale != null) {
      button = ScaleTransition(scale: scale, child: button);
    }

    return button;
  }

  /// Builds the product details content section.
  Widget _buildDetailsContent() {
    final product = widget.product;

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Association badge
          if (widget.associationName != null) _buildAssociationBadge(),

          // Product name
          Text(
            product.name,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Price section
          _buildPriceSection(product.price),
          const SizedBox(height: 24),

          // Description card
          _buildDescriptionCard(product.description),
          const SizedBox(height: 24),

          // Support message card
          if (widget.associationName != null)
            _buildSupportMessageCard(widget.associationName!),
        ],
      ),
    );
  }

  Widget _buildAssociationBadge() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: _navigateToAssociation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.store, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                widget.associationName!,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(double price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2),
          style: GoogleFonts.cairo(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF030213),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'دينار',
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF030213),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف المنتج',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description.isNotEmpty
                ? description
                : 'لا يوجد وصف متاح لهذا المنتج.',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportMessageCard(String associationName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFF3E8FF)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Text(
        'عائدات هذا المنتج تذهب لدعم برامج $associationName',
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: const Color(0xFF030213).withOpacity(0.8),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds the fixed bottom action bar using the shared ProductBottomBar.
  Widget _buildBottomActionBar(int quantity) {
    return ProductBottomBar(
      quantity: quantity,
      onIncrement: _handleIncrement,
      onDecrement: _handleDecrement,
      onAddToCart: _handleAddToCart,
      price: widget.product.price,
      addKey: _addKey,
    );
  }
}

/// Inline image carousel for product details
class _ProductImageCarouselInline extends StatefulWidget {
  const _ProductImageCarouselInline({
    required this.imageUrls,
    required this.resolveUrl,
  });

  final List<String> imageUrls;
  final String Function(String?) resolveUrl;

  @override
  State<_ProductImageCarouselInline> createState() =>
      _ProductImageCarouselInlineState();
}

class _ProductImageCarouselInlineState
    extends State<_ProductImageCarouselInline> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreenViewer(int initialIndex) {
    final images = widget.imageUrls.where((url) => url.isNotEmpty).toList();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullScreenImageViewer(
            imageUrls: images,
            initialIndex: initialIndex,
            resolveUrl: widget.resolveUrl,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.where((url) => url.isNotEmpty).toList();

    if (images.isEmpty) {
      return _buildPlaceholder();
    }

    return Stack(
      children: [
        // Image PageView
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            final imageUrl = widget.resolveUrl(images[index]);
            return GestureDetector(
              onTap: () => _openFullScreenViewer(index),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoading();
                },
              ),
            );
          },
        ),

        // Page indicators (only show if more than 1 image)
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF030213)
                        : const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

        // Image counter (top right)
        if (images.length > 1)
          Positioned(
            top: 60,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentPage + 1}/${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Tap hint icon (bottom right)
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF030213),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Full-screen image viewer with zoom and swipe support
class _FullScreenImageViewer extends StatefulWidget {
  const _FullScreenImageViewer({
    required this.imageUrls,
    required this.initialIndex,
    required this.resolveUrl,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String Function(String?) resolveUrl;

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Swipeable images with zoom
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.resolveUrl(widget.imageUrls[index]);
                return InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 64,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),

            // Image counter (only show if multiple images)
            if (widget.imageUrls.length > 1)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

            // Page indicators at bottom (only show if multiple images)
            if (widget.imageUrls.length > 1)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.imageUrls.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
