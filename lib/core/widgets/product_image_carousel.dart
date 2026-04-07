import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';

/// A swipeable image carousel widget for displaying multiple product images.
///
/// Features:
/// - PageView for smooth horizontal swiping
/// - Page indicator dots
/// - Placeholder for missing images
/// - Resolves relative URLs
class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    this.aspectRatio = 1.0,
    this.borderRadius = 0,
    this.indicatorColor = const Color(0xFF030213),
    this.inactiveIndicatorColor = const Color(0xFFE5E5E5),
  });

  /// List of image URLs to display
  final List<String> imageUrls;

  /// Aspect ratio of the carousel (default 1:1)
  final double aspectRatio;

  /// Border radius for the carousel
  final double borderRadius;

  /// Active indicator dot color
  final Color indicatorColor;

  /// Inactive indicator dot color
  final Color inactiveIndicatorColor;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
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

  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmed = path.trim();
    if (trimmed.startsWith('http')) return trimmed;
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.where((url) => url.isNotEmpty).toList();

    if (images.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _buildPlaceholder(),
      );
    }

    return Stack(
      children: [
        // Image PageView
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final imageUrl = _resolveImageUrl(images[index]);
                return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingIndicator();
                  },
                );
              },
            ),
          ),
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
                        ? widget.indicatorColor
                        : widget.inactiveIndicatorColor,
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
            top: 16,
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

  Widget _buildLoadingIndicator() {
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
