import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/product_detail/product_info.dart';
import '../widgets/product_detail/product_bottom_bar.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

@immutable
class ProductDetailPageArgs {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final ScrollController? scrollController;

  const ProductDetailPageArgs({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.scrollController,
  });
}

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final ScrollController? scrollController;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.scrollController,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  final GlobalKey _addKey = GlobalKey();
  late AnimationController _favoriteAnimationController;
  late Animation<double> _favoriteScaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;

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

    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Toggle favorite using unified wishlistControllerProvider
    await ref.read(wishlistControllerProvider.notifier).toggle(widget.product);

    widget.onFavoriteToggle.call();
  }

  void _increment() {
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

  void _decrement() {
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

  void _handleAddToCart() {
    context.pop();
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
    final quantity = ref.watch(
      cartQuantityForProductIdProvider(widget.product.id),
    );

    // Get favorite state from wishlist controller for real-time updates
    final isFavorite = ref
        .watch(wishlistControllerProvider)
        .items
        .any((p) => p.id == widget.product.id);

    // Get all images using the allImageUrls getter
    final imageUrls = widget.product.allImageUrls;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Scrollable content
            SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: [
                  // Product image carousel section with overlay buttons
                  _buildImageSection(imageUrls, isFavorite),
                  SizedBox(height: context.hp(3)),
                  ProductInfo(product: widget.product),
                  // Bottom padding for fixed bottom bar
                  const SizedBox(height: 120),
                ],
              ),
            ),
            // Fixed bottom action bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ProductBottomBar(
                quantity: quantity,
                onIncrement: _increment,
                onDecrement: _decrement,
                onAddToCart: _handleAddToCart,
                price: widget.product.price,
                addKey: _addKey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the product image section with carousel and overlay buttons.
  Widget _buildImageSection(List<String> imageUrls, bool isFavorite) {
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
          // Overlay buttons for navigation and wishlist
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
                  onTap: () => context.pop(),
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
}

/// Inline image carousel for product details with full-screen viewer
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
