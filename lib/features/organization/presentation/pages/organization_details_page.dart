import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/app/router.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import '../controllers/organization_details_controller.dart';
import '../providers/organization_provider.dart';
import '../widgets/organization_product_card.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/star_rating_widget.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rate_store_dialog.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';
import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller_provider.dart';

/// Organization Details Page - Displays charitable organization information
/// with RTL Arabic support and Material Design 3 components.
class OrganizationDetailsPage extends ConsumerWidget {
  const OrganizationDetailsPage({super.key, this.organizationId});

  final String? organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load organization if not already loaded
    _loadIfNeeded(ref);

    final state = ref.watch(organizationDetailsControllerProvider);
    final orgImageAsync = state.organization == null
        ? null
        : ref.watch(orgProfileImageProvider(state.organization!.id));
    final productsAsync = state.organization == null
        ? null
        : ref.watch(
            organizationProductsBySellerIdProvider(
              state.organization!.ownerProfileId.toString(),
            ),
          );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF030213)),
              )
            : state.error != null
            ? _buildErrorState(context, state.error!, ref)
            : state.organization != null
            ? _buildContent(
                context,
                ref,
                state.organization!,
                productsAsync,
                orgImageAsync,
              )
            : const Center(child: Text('لا توجد بيانات')),
      ),
    );
  }

  void _loadIfNeeded(WidgetRef ref) {
    final id = organizationId;
    if (id == null || id.isEmpty) return;

    // Check if we need to load this organization
    final state = ref.read(organizationDetailsControllerProvider);
    if (state.organization?.id.toString() != id && !state.isLoading) {
      Future.microtask(
        () => ref
            .read(organizationDetailsControllerProvider.notifier)
            .loadOrganization(id),
      );
    }
  }

  void _navigateToProductDetails(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    final state = ref.read(organizationDetailsControllerProvider);
    final organization = state.organization;

    context.push(
      '/org-product-details',
      extra: OrgProductDetailsArgs(
        product: product,
        isFavorite: false,
        associationName: organization?.name,
        associationId: organization?.id.toString(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.sp(64),
            color: Colors.grey[400],
          ),
          SizedBox(height: context.hp(2)),
          Text(
            error,
            style: GoogleFonts.cairo(
              fontSize: context.sp(16),
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: context.hp(2)),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(organizationDetailsControllerProvider.notifier)
                  .refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF030213),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'إعادة المحاولة',
              style: GoogleFonts.cairo(fontSize: context.sp(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OrganizationDetails organization,
    AsyncValue<List<Product>>? productsAsync,
    AsyncValue<OrgImage?>? orgImageAsync,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(organizationDetailsControllerProvider.notifier)
            .refresh();
        // Also refresh products
        ref.invalidate(
          organizationProductsBySellerIdProvider(
            organization.ownerProfileId.toString(),
          ),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section with Cover Image
            _buildHeaderSection(context, ref, organization, orgImageAsync),
            // About Section
            _buildAboutSection(context, ref, organization),
            SizedBox(height: context.hp(3)),
            if (productsAsync != null)
              _buildProductsSection(context, ref, productsAsync),
            SizedBox(height: context.hp(3)),
            // Support Message
            _buildSupportMessage(context),
            SizedBox(height: context.hp(3)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    WidgetRef ref,
    OrganizationDetails organization,
    AsyncValue<OrgImage?>? orgImageAsync,
  ) {
    final fallbackUrl = _resolveImageUrl(organization.ownerProfileImageUrl);
    final coverImageUrl =
        orgImageAsync?.maybeWhen(
          data: (img) =>
              img?.path == null ? fallbackUrl : _resolveImageUrl(img!.path),
          orElse: () => fallbackUrl,
        ) ??
        fallbackUrl;
    return SizedBox(
      height: context.hp(31),
      child: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFF6FF), // blue-50
                  Color(0xFFFAF5FF), // purple-50
                ],
              ),
            ),
          ),
          // Cover Image with rounded corners - centered and bigger
          Positioned(
            left: context.wp(4),
            right: context.wp(4),
            top: MediaQuery.of(context).padding.top + context.hp(6),
            bottom: context.hp(2.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: 0.9,
                child: Image.network(
                  coverImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEFF6FF), Color(0xFFFAF5FF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.business,
                        size: context.sp(64),
                        color: const Color(0xFF6B7280),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Top Bar with Back Button, Settings and Cart
          Positioned(
            top: MediaQuery.of(context).padding.top + context.hp(1),
            left: context.wp(4),
            right: context.wp(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Cart and Wishlist icons
                Row(
                  children: [
                    _buildCartIcon(context, ref),
                    SizedBox(width: context.wp(2)),
                    _buildWishlistIcon(context, ref),
                  ],
                ),
                // Right side - Back button
                _buildBackButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.wp(10),
        height: context.wp(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 83, 125, 93),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: context.sp(20)),
            if (badge > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badge',
                    style: TextStyle(
                      fontSize: context.sp(10),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context, WidgetRef ref) {
    final cartBadge = ref.watch(cartTotalQuantityProvider);
    return _buildCircleIcon(
      context,
      icon: Icons.shopping_bag_outlined,
      onTap: () => context.push('/cart'),
      badge: cartBadge,
    );
  }

  Widget _buildWishlistIcon(BuildContext context, WidgetRef ref) {
    // Use wishlistControllerProvider for unified state with product cards
    final wishlistState = ref.watch(wishlistControllerProvider);
    final wishlistBadge = wishlistState.items.length;
    return _buildCircleIcon(
      context,
      icon: Icons.favorite,
      onTap: () => context.push('/wishlist'),
      badge: wishlistBadge,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: context.wp(10),
        height: context.wp(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.3),
              BlendMode.srcOver,
            ),
            child: Icon(
              Icons.arrow_forward,
              size: context.sp(20),
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    WidgetRef ref,
    OrganizationDetails organization,
  ) {
    return Transform.translate(
      offset: Offset(0, -context.hp(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.wp(6)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(context.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organization Name with Settings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      organization.name,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  ref
                      .watch(currentSellerHasOrgProvider)
                      .when(
                        data: (hasOrg) {
                          if (!hasOrg) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: () => context.push('/organization-admin'),
                            child: Container(
                              width: context.wp(10),
                              height: context.wp(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.settings_outlined,
                                size: context.sp(22),
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                ],
              ),
              SizedBox(height: context.hp(2)),
              // Divider
              Container(height: 1, color: const Color(0xFFE5E7EB)),
              SizedBox(height: context.hp(2)),
              // Title
              Text(
                'نبذة عن الجمعية',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: context.hp(1.5)),
              // Description
              Text(
                organization.description,
                style: GoogleFonts.cairo(
                  fontSize: context.sp(14),
                  height: 1.6,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: context.hp(2)),
              // Divider
              Container(height: 1, color: const Color(0xFFE5E7EB)),
              SizedBox(height: context.hp(2)),
              // Contact Information
              _buildContactItem(
                context,
                icon: Icons.location_on,
                text: _formatLocation(
                  organization.storeGovernment,
                  organization.storeCountry,
                ),
                isLtr: false,
                color: TColors.primary,
              ),
              SizedBox(height: context.hp(1)),
              _buildContactItem(
                context,
                icon: Icons.phone,
                text: organization.storePhone ?? '- - -',
                isLtr: false,
              ),
              SizedBox(height: context.hp(1)),
              // Rating Section with StarRatingWidget and Rate button
              Row(
                children: [
                  StarRatingWidget(
                    rating: organization.averageRating ?? 0.0,
                    size: context.sp(18),
                    showValue: true,
                  ),
                  SizedBox(width: context.wp(2)),
                  Text(
                    '(${organization.ratingCount ?? 0} تقييم)',
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(14),
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showRateStoreDialog(
                      context,
                      ref,
                      organization.ownerProfileId,
                      organization.name,
                    ),
                    icon: Icon(
                      Icons.star_outline_rounded,
                      size: context.sp(16),
                      color: TColors.primary,
                    ),
                    label: Text(
                      'قيّم',
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(13),
                        color: TColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.wp(2),
                        vertical: context.hp(0.3),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.hp(1.5)),
              // View All Reviews Button
              OutlinedButton.icon(
                onPressed: () => _showReviewsBottomSheet(
                  context,
                  ref,
                  organization.ownerProfileId,
                  organization.name,
                ),
                icon: Icon(Icons.reviews_outlined, size: context.sp(16)),
                label: Text(
                  'عرض جميع التقييمات',
                  style: GoogleFonts.cairo(fontSize: context.sp(13)),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: TColors.primary,
                  side: const BorderSide(color: TColors.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.wp(4),
                    vertical: context.hp(1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboardButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.push('/organization-admin'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A1A1A),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        minimumSize: Size(double.infinity, context.hp(6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(
          horizontal: context.wp(4),
          vertical: context.hp(1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لوحة التحكم (للمسؤولين)',
            style: GoogleFonts.cairo(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(width: context.wp(2)),
          Icon(
            Icons.settings,
            size: context.sp(20),
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isLtr,
    Color color = const Color(0xFF6B7280),
  }) {
    return Row(
      children: [
        Icon(icon, size: context.sp(16), color: color),
        SizedBox(width: context.wp(2)),
        Expanded(
          child: Directionality(
            textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: context.sp(14),
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmed = path.trim();
    if (trimmed.startsWith('http')) return trimmed;
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  String _formatLocation(String? government, String? country) {
    final parts = [
      if (government != null && government.trim().isNotEmpty) government.trim(),
      if (country != null && country.trim().isNotEmpty) country.trim(),
    ];
    return parts.isEmpty ? '- - -' : parts.join(' - ');
  }

  void _showRateStoreDialog(
    BuildContext context,
    WidgetRef ref,
    int sellerId,
    String storeName,
  ) async {
    final result = await RateStoreDialog.show(
      context,
      sellerId: sellerId,
      storeName: storeName,
    );

    // Refresh ratings if a rating was submitted
    if (result == true) {
      ref.invalidate(storeRatingsProvider(sellerId));
    }
  }

  void _showReviewsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    int sellerId,
    String storeName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'تقييمات $storeName',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Ratings list
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final ratingsAsync = ref.watch(
                        storeRatingsProvider(sellerId),
                      );
                      return ratingsAsync.when(
                        data: (ratings) => ratings.isEmpty
                            ? Center(
                                child: Text(
                                  'لا توجد تقييمات بعد',
                                  style: GoogleFonts.cairo(
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: ratings.length,
                                itemBuilder: (context, index) {
                                  final rating = ratings[index];
                                  return _buildReviewItem(context, rating);
                                },
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 8),
                              Text(e.toString()),
                              TextButton(
                                onPressed: () => ref.invalidate(
                                  storeRatingsProvider(sellerId),
                                ),
                                child: Text(
                                  'إعادة المحاولة',
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, dynamic rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: TColors.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مستخدم #${rating.userId ?? 0}',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    StarRatingWidget(
                      rating: rating.rating.toDouble(),
                      size: 14,
                    ),
                  ],
                ),
              ),
              Text(
                '${rating.createdAt.day}/${rating.createdAt.month}/${rating.createdAt.year}',
                style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              rating.comment!,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(4)),
      child: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'فشل في تحميل المنتجات',
            style: GoogleFonts.cairo(color: const Color(0xFF6B7280)),
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Text(
                'لا توجد منتجات',
                style: GoogleFonts.cairo(color: const Color(0xFF6B7280)),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المنتجات',
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    '${products.length} منتج',
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(14),
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.hp(2)),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  if (width.isInfinite || width <= 20) {
                    return const SizedBox.shrink();
                  }

                  final itemWidth = (width - 20) / 2;
                  final calculatedRatio = itemWidth / (itemWidth + 155);
                  final childAspectRatio =
                      (calculatedRatio <= 0 || calculatedRatio.isNaN)
                      ? 0.65
                      : calculatedRatio;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      // Create a product with resolved imageUrl for display
                      final displayProduct = Product(
                        id: product.id,
                        name: product.name,
                        description: product.description,
                        price: product.price,
                        imageUrl: _resolveImageUrl(product.imageUrl),
                        imageUrls: product.imageUrls
                            .map(_resolveImageUrl)
                            .toList(),
                        sellerId: product.sellerId,
                        category: product.category,
                        isCustomizable: product.isCustomizable,
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                      );
                      return OrganizationProductCard(
                        product: displayProduct,
                        onTap: () =>
                            _navigateToProductDetails(context, ref, product),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSupportMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(4)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEFF6FF), // blue-50
              Color(0xFFFAF5FF), // purple-50
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDBEAFE), // blue-100
          ),
        ),
        padding: EdgeInsets.all(context.wp(5)),
        child: Text(
          'جميع عائدات المنتجات تذهب لدعم برامج ومشاريع الجمعية',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: context.sp(14),
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
