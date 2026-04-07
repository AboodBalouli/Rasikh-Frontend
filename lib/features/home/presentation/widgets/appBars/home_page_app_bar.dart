import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/organization/presentation/providers/organization_provider.dart';
import 'package:go_router/go_router.dart';

/// A clean architecture presentation widget for the home page app bar.
/// This widget is purely presentational and receives all actions via callbacks,
/// maintaining separation of concerns between UI and business logic.
class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onSearchSubmitted,
    required this.onCameraSearchPressed,
    required this.onNotificationPressed,
    required this.onCartPressed,
  });

  /// Callback when the menu button is pressed
  final VoidCallback onMenuPressed;

  /// Callback when text search is submitted
  final ValueChanged<String> onSearchSubmitted;

  /// Callback when the camera search button is pressed
  final VoidCallback onCameraSearchPressed;

  /// Callback when the notification button is pressed
  final VoidCallback onNotificationPressed;

  /// Callback when the cart button is pressed
  final VoidCallback onCartPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Consumer(
        builder: (context, ref, _) {
          Future<void> handleStoreTap() async {
            final token = await ref.read(authTokenProvider.future);
            if (token == null) {
              if (context.mounted) context.push('/login');
              return;
            }

            final role = await AuthLocalDataSource().getRole();
            final normalizedRole = role?.trim().toUpperCase();

            if (!context.mounted) return;

            if (normalizedRole == 'SELLER') {
              // Check if seller has an organization
              try {
                final checkHasOrgUseCase = ref.read(
                  checkSellerHasOrgUseCaseProvider,
                );
                final hasOrg = await checkHasOrgUseCase();

                if (!context.mounted) return;

                if (hasOrg) {
                  // Seller has an org - go to admin products screen
                  context.push('/organization-admin');
                } else {
                  // Seller without org - go to seller page
                  context.push('/seller-page');
                }
              } catch (e) {
                // On error, default to seller page
                if (context.mounted) {
                  context.push('/seller-page');
                }
              }
              return;
            }

            context.push('/create-store-choice');
          }

          return FutureBuilder<String?>(
            future: AuthLocalDataSource().getRole(),
            builder: (context, snapshot) {
              final normalizedRole = snapshot.data?.trim().toUpperCase();
              final isSeller = normalizedRole == 'SELLER';

              return Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: handleStoreTap,
                        icon: const Icon(
                          Icons.storefront_outlined,
                          color: Color.fromARGB(255, 83, 125, 93),
                        ),
                        tooltip: isSeller ? 'لوحة المتجر' : 'انشاء متجر',
                      ),
                      Text(
                        isSeller ? 'متجري' : 'انشاء متجر',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 83, 125, 93),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث ',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: onSearchSubmitted,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: onNotificationPressed,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color.fromARGB(255, 83, 125, 93),
                    ),
                    tooltip: 'Notifications',
                  ),
                  IconButton(
                    onPressed: onCartPressed,
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color.fromARGB(255, 83, 125, 93),
                    ),
                    tooltip: 'Cart',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
