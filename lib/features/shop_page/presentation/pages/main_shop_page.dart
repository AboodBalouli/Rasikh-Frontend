import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/special_orders_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'package:flutter_application_1/app/controllers/shop_controller.dart';
import 'package:flutter_application_1/app/providers/shop_providers.dart';
import 'package:flutter_application_1/features/shop_page/presentation/providers/store_products_provider.dart';
import '../controllers/store_info_controller.dart';
import '../widgets/shop_tabs.dart';
import '../widgets/item_card.dart';
import '../widgets/store_info_section.dart';

class MainShopPage extends ConsumerStatefulWidget {
  final String storeId;

  const MainShopPage({super.key, required this.storeId});

  @override
  ConsumerState<MainShopPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainShopPage> {
  int _selectedTab = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isSliverAppBarExpanded = true;

  // Calculate sliver expanded height based on screen height (responsive)
  double _getSliverExpandedHeight(BuildContext context) {
    return Responsive.hp(context, 40); // 40% of screen height
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) {
      final sliverHeight = _getSliverExpandedHeight(context);
      setState(() {
        _isSliverAppBarExpanded =
            _scrollController.hasClients &&
            _scrollController.offset < (sliverHeight - kToolbarHeight);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopController = ref.watch(shopControllerProvider);
    final storeProductsAsync = ref.watch(storeProductsProvider(widget.storeId));
    final storeProducts = storeProductsAsync.asData?.value ?? const [];
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: provider.ChangeNotifierProvider(
        create: (_) => StoreInfoController()..load(widget.storeId),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(storeProductsProvider(widget.storeId));
                provider.Provider.of<StoreInfoController>(
                  context,
                  listen: false,
                ).load(widget.storeId);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  /// ================= SLIVER APP BAR =================
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _getSliverExpandedHeight(context),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color.fromARGB(255, 83, 125, 93),
                      ),
                      onPressed: () => context.pop(),
                    ),


                    centerTitle: true,

                    actions: _buildHeaderActions(
                      context,
                      shopController,
                      cartBadge: ref.watch(cartTotalQuantityProvider),
                    ),

                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// خلفية ناعمة
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF3F3F3), Color(0xFFFBFBFD)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 12,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Store Logo from profile picture
                                provider.Consumer<StoreInfoController>(
                                  builder: (context, ctrl, _) {
                                    final profilePicUrl =
                                        ctrl.info?.profilePictureUrl;
                                    final hasProfilePic =
                                        profilePicUrl != null &&
                                        profilePicUrl.trim().isNotEmpty;

                                    return SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          'assets/images/logobg.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 18,
                                        sigmaY: 18,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.65,
                                          ),
                                          borderRadius: BorderRadius.circular(40),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.03,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.01,
                                              ),
                                              blurRadius: 40,
                                              offset: const Offset(0, 20),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            provider.Consumer<
                                              StoreInfoController
                                            >(
                                              builder: (context, ctrl, _) {
                                                final profilePicUrl =
                                                    ctrl.info?.profilePictureUrl;
                                                final hasProfilePic =
                                                    profilePicUrl != null &&
                                                    profilePicUrl
                                                        .trim()
                                                        .isNotEmpty;

                                                return Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  child: ClipOval(
                                                    child: hasProfilePic
                                                        ? Image.network(
                                                            '${AppConfig.apiBaseUrl}$profilePicUrl',
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          8,
                                                                        ),
                                                                    child: Image.asset(
                                                                      'assets/images/logo2.png',
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  );
                                                                },
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8,
                                                                ),
                                                            child: Image.asset(
                                                              'assets/images/logo2.png',
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 16),

                                            /// Store Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  provider.Consumer<
                                                    StoreInfoController
                                                  >(
                                                    builder: (context, ctrl, _) {
                                                      final info = ctrl.info;
                                                      final title =
                                                          info?.storeName ??
                                                          AppStrings.storeTitle;
                                                      final storeDescription =
                                                          (info?.description
                                                                  .trim()
                                                                  .isNotEmpty ??
                                                              false)
                                                          ? info!.description
                                                          : AppStrings
                                                                .storeDescription;
                                                      final ratingText =
                                                          info?.averageRating ==
                                                              null
                                                          ? null
                                                          : info!.averageRating!
                                                                .toStringAsFixed(
                                                                  1,
                                                                );

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            title,
                                                            style: const TextStyle(
                                                              fontFamily: AppFonts
                                                                  .parastoo,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            storeDescription,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontFamily: AppFonts
                                                                  .parastoo,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          if (ratingText != null) ...[
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 14,
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  ratingText,
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 13,
                                                                  ),
                                                                ),
                                                                if (info?.ratingCount !=
                                                                    null) ...[
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    '(${info!.ratingCount})',
                                                                    style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          ],
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= TABS =================
                  SliverToBoxAdapter(
                    child: ShopTabs(
                      selectedTab: _selectedTab,
                      onProductsTap: () => setState(() => _selectedTab = 0),
                      onStoreInfoTap: () => setState(() => _selectedTab = 1),
                      onSpecialOrdersTap: () =>
                          setState(() => _selectedTab = 2),
                    ),
                  ),

                  /// ================= PRODUCTS =================
                  if (_selectedTab == 0)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverToBoxAdapter(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            if (width.isInfinite || width <= 20) {
                              return const SizedBox.shrink();
                            }

                            final itemWidth = (width - 20) / 2;
                            final calculatedRatio =
                                itemWidth / (itemWidth + 155);
                            final childAspectRatio =
                                (calculatedRatio <= 0 || calculatedRatio.isNaN)
                                ? 0.65
                                : calculatedRatio;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: childAspectRatio,
                                  ),
                              itemCount: storeProducts.length,
                              itemBuilder: (context, index) {
                                final product = storeProducts[index];
                                return ItemCard(
                                  product: product,
                                  isFavorite: shopController.wishlist.contains(
                                    product,
                                  ),
                                  onFavoriteToggle: () =>
                                      shopController.toggleWishlist(product),
                                  onOpenCart: () {
                                    context.push('/cart');
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  else if (_selectedTab == 1)
                    SliverToBoxAdapter(
                      child: provider.Consumer<StoreInfoController>(
                        builder: (context, ctrl, _) {
                          if (ctrl.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return ctrl.info == null
                              ? const SizedBox()
                              : StoreInfoSection(info: ctrl.info!);
                        },
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: provider.Consumer<StoreInfoController>(
                        builder: (context, ctrl, _) {
                          if (ctrl.isLoading || ctrl.info == null) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return SpecialOrdersSection(
                            sellerProfileId: widget.storeId,
                            sellerStoreName: ctrl.info?.storeName ?? 'المتجر',
                          );
                        },
                      ),
                    ),

                  if (_selectedTab == 0)
                    SliverToBoxAdapter(
                      child: storeProductsAsync.when(
                        data: (items) => items.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Text('لا توجد منتجات لهذا المتجر'),
                                ),
                              )
                            : const SizedBox.shrink(),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(child: Text(e.toString())),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeaderActions(
    BuildContext context,
    ShopController shopController, {
    required int cartBadge,
  }) {
    return [
      _circleIcon(Icons.search, () {
        context.push('/seller-search');
      }),
      _circleIcon(Icons.favorite, () {
        context.push('/wishlist');
      }, badge: shopController.wishlist.length),
      _circleIcon(Icons.shopping_bag_outlined, () {
        context.push('/cart');
      }, badge: cartBadge),
      const SizedBox(width: 8),
    ];
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap, {int badge = 0}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 83, 125, 93),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            if (badge > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      fontSize: 10,
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
}
