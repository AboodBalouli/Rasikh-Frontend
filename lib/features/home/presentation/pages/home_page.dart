import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/carouselSlider/event_promo_slider.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/clickable_container_list.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/appBars/home_page_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/largeCategories/large_category_container.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/image_generate_card.dart';
import 'dart:ui';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import '../widgets/appBars/nav_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _handleMenuPressed() {
    // TODO: Implement menu functionality
  }

  void _handleSearchSubmitted(String searchQuery) {
    // TODO: Implement text search functionality
    debugPrint('Search for: $searchQuery');
  }

  void _handleCameraSearchPressed() async {
    final authLocalDataSource = AuthLocalDataSource();
    final token = await authLocalDataSource.getToken();

    if (token == null || token.isEmpty) {
      if (!mounted) return;
      _showGuestLoginDialog(iconData: Icons.camera_alt);
    } else {
      context.push('/image-generate');
    }
  }

  void _handleNotificationPressed() {
    context.push('/notifications');
  }

  void _handleCartPressed() async {
    final authLocalDataSource = AuthLocalDataSource();
    final token = await authLocalDataSource.getToken();

    if (token == null || token.isEmpty) {
      if (!mounted) return;
      _showGuestLoginDialog();
    } else {
      context.push('/cart');
    }
  }

  void _showGuestLoginDialog({
    IconData iconData = Icons.shopping_cart_outlined,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: IntrinsicWidth(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(iconData, size: 44, color: TColors.primary),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.youNeedAccount,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: TColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: AppStrings.login,
                                  onPressed: () {
                                    dialogContext.pop();
                                    context.push('/login');
                                  },
                                  backgroundColor: TColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  text: AppStrings.register,
                                  onPressed: () {
                                    dialogContext.pop();
                                    context.push('/register');
                                  },
                                  backgroundColor: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => dialogContext.pop(),
                            child: Text(
                              AppStrings.cancel,
                              style: const TextStyle(
                                fontSize: 14,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch locale to rebuild when language changes
    final localeState = ref.watch(localeProvider);

    return Scaffold(
      appBar: HomePageAppBar(
        onMenuPressed: _handleMenuPressed,
        onSearchSubmitted: _handleSearchSubmitted,
        onCameraSearchPressed: _handleCameraSearchPressed,
        onNotificationPressed: _handleNotificationPressed,
        onCartPressed: _handleCartPressed,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logobg.png',
                  height: context.hp(14),
                  fit: BoxFit.contain,
                ),
                const EventPromoSlider(),
                const ClickableContainerList(),
                SizedBox(height: context.hp(1)),
                ImageGenerateCard(onCameraPressed: _handleCameraSearchPressed),
                SizedBox(height: context.hp(1.5)),
                Padding(
                  padding: Responsive.paddingH(context),
                  child: Align(
                    alignment: localeState.isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      AppStrings.discoverStores,
                      style: TextStyle(
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w600,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.hp(1.5)),
                const LargeCategoriesContainer(),
                SizedBox(height: context.hp(12)),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: NavBar(currentIndex: 0),
          ),
        ],
      ),
    );
  }
}
