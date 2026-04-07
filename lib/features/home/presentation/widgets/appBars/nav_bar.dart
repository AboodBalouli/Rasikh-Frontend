import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/app/providers/shop_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';

List<IconData> navIcons = [Icons.home, Icons.favorite, Icons.person];

class NavBar extends ConsumerStatefulWidget {
  final int currentIndex;

  const NavBar({super.key, this.currentIndex = 0});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  late int selectedIndex;
  static const Color _selectedColor = Color.fromARGB(255, 83, 148, 93);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final shopController = ref.watch(shopControllerProvider);
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);

    final navTitle = [
      AppStrings.home,
      AppStrings.favorites,
      AppStrings.account,
    ];

    return Container(
      height: 65,
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () async {
              if (widget.currentIndex == index) return;

              if (index == 0) {
                context.go('/home');
                return;
              }

              if (index == 1) {
                final authLocalDataSource = AuthLocalDataSource();
                final token = await authLocalDataSource.getToken();
                if (token == null || token.isEmpty) {
                  if (!context.mounted) return;
                  _showGuestLoginDialog(context);
                } else {
                  context.push('/wishlist');
                }
                return;
              }

              if (index == 2) {
                final authLocalDataSource = AuthLocalDataSource();
                final token = await authLocalDataSource.getToken();
                if (token == null || token.isEmpty) {
                  context.push('/guest-page');
                } else {
                  context.push('/user-settings');
                }
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 9),
                if (index == 1 && shopController.wishlist.isNotEmpty)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? _selectedColor : Colors.grey,
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${shopController.wishlist.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Icon(icon, color: isSelected ? _selectedColor : Colors.grey),
                const SizedBox(height: 3),
                Text(
                  navTitle[index],
                  style: TextStyle(
                    color: isSelected ? _selectedColor : Colors.grey,
                  ),
                ),
                const SizedBox(height: 9),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showGuestLoginDialog(BuildContext context) {
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
                          Icon(
                            Icons.favorite_outline,
                            size: 44,
                            color: TColors.primary,
                          ),
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
}
