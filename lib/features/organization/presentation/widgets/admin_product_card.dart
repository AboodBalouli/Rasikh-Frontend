import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import '../../domain/entities/seller_product.dart';

/// A card widget for displaying a product in the admin dashboard.
/// Shows product image, name, price, rating, and action buttons.
class AdminProductCard extends StatelessWidget {
  const AdminProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onToggleVisibility,
    this.isToggling = false,
  });

  final SellerProduct product;
  final VoidCallback onEdit;
  final VoidCallback onToggleVisibility;
  final bool isToggling;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: product.isVisible ? 1.0 : 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: product.isVisible ? Colors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: product.isVisible
                ? Colors.black.withValues(alpha: 0.1)
                : const Color(0xFFDC2626).withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Product Image
            _buildProductImage(),
            const SizedBox(width: 16),
            // Product Info
            Expanded(child: _buildProductInfo()),
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = product.primaryImageUrl;
    final hasImage = imageUrl.isNotEmpty;

    // Build full URL for the image
    String fullImageUrl = imageUrl;
    if (hasImage && !imageUrl.startsWith('http')) {
      fullImageUrl = '${AppConfig.apiBaseUrl}$imageUrl';
    }

    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: hasImage
              ? Image.network(
                  fullImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: Color(0xFF6B7280),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: Color(0xFF6B7280),
                  ),
                ),
        ),
        // Hidden indicator overlay
        if (!product.isVisible)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.visibility_off,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name with visibility indicator
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: product.isVisible
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFF6B7280),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!product.isVisible) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppStrings.hidden,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        // Price
        Text(
          '${product.price.toStringAsFixed(0)} ${AppStrings.currency}',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF030213),
          ),
        ),
        const SizedBox(height: 8),
        // Rating & Sales Badge
        _buildInfoBadges(),
      ],
    );
  }

  Widget _buildInfoBadges() {
    return Row(
      children: [
        // Rating Badge
        if (product.rating > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 12, color: Color(0xFFEA580C)),
                const SizedBox(width: 4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        // Sales Badge
        if (product.totalSales > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Text(
              '${product.totalSales} ${AppStrings.sales}',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF15803D),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Visibility Toggle Button
        _buildVisibilityToggleButton(),
        const SizedBox(height: 8),
        // Edit Button
        _buildActionButton(
          icon: Icons.edit_outlined,
          iconColor: const Color(0xFF6B7280),
          onTap: onEdit,
        ),
      ],
    );
  }

  Widget _buildVisibilityToggleButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isToggling ? null : onToggleVisibility,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: product.isVisible
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
            border: Border.all(
              color: product.isVisible
                  ? const Color(0xFFBBF7D0)
                  : const Color(0xFFFECACA),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isToggling
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF6B7280),
                  ),
                )
              : Icon(
                  product.isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 16,
                  color: product.isVisible
                      ? const Color(0xFF15803D)
                      : const Color(0xFFDC2626),
                ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}
