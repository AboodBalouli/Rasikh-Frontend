/* 
  Defines all app routes using GoRouter.
  Every screen in every feature is registered here.

 */

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/seller_page/presentation/pages/create_store_page.dart';
import 'package:flutter_application_1/features/seller_page/presentation/pages/seller_page.dart';
import 'package:flutter_application_1/features/seller_page/presentation/pages/store_creation_success_page.dart';

import 'package:flutter_application_1/features/ai_chat/presentation/pages/ai_chat_page.dart';

import 'package:flutter_application_1/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:flutter_application_1/features/user_settings/presentation/pages/user_settings_page.dart';
import 'package:flutter_application_1/features/user_settings/presentation/widgets/profile_settings_section.dart';
import 'package:flutter_application_1/features/user_settings/presentation/widgets/language_settings_section.dart';
import 'package:flutter_application_1/features/user_settings/presentation/widgets/password_settings_section.dart';
import 'package:flutter_application_1/features/markets/presentation/pages/markets_page.dart';
import 'package:flutter_application_1/features/faq/presentation/pages/faq_page.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/org_application_success_page.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/order_history/past_orders_page.dart';
import 'package:flutter_application_1/features/public_orders/presentation/pages/create_public_order.dart';
import 'package:flutter_application_1/features/public_orders/presentation/pages/edit_public_order_page.dart';
import 'package:flutter_application_1/features/public_orders/presentation/pages/public_order_details_page.dart';
import 'package:flutter_application_1/features/public_orders/presentation/pages/public_orders_page.dart';
import 'package:flutter_application_1/features/settings/presentation/screens/account_details.dart';
import 'package:flutter_application_1/features/settings/presentation/screens/change_password_page.dart';

import 'package:flutter_application_1/features/settings/presentation/screens/payment_methods_page.dart';
import 'package:flutter_application_1/features/settings/presentation/screens/personal_info_edit_page.dart';
import 'package:flutter_application_1/features/settings/presentation/screens/store_info_page.dart';
import 'package:flutter_application_1/features/user_profile/presentation/pages/seller_store_settings_page.dart';
//import 'package:flutter_application_1/features/organization/admin_legacy/organization_admin/presentation/screens/verification_page.dart';
import 'package:flutter_application_1/features/products/presentation/pages/add_product_to_sell_page.dart';
import 'package:flutter_application_1/features/products/presentation/pages/organization_product_details_page.dart';
import 'package:flutter_application_1/features/seller_page/presentation/widgets/edit_product_page.dart';
import 'package:flutter_application_1/core/entities/product_card_model.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/organizations_category_page.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/organization_details_page.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/admin/admin_products_screen.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/admin/edit_organization_info_screen.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/admin/add_edit_product_screen.dart';
import 'package:flutter_application_1/features/events/presentation/pages/season_stores_page.dart';
import 'package:flutter_application_1/features/events/presentation/pages/event_detail_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/wallet_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/register_login.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_application_1/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_1/features/home/presentation/pages/notifications_page.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/seller_entry_page.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/store_creation_choice_page.dart';
import 'package:flutter_application_1/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/checkout_page.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/order_sent.dart'
    as cart_order_sent;
import 'package:flutter_application_1/features/custom_orders/presentation/pages/create_custom_order_page.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/product_detail_page.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/search_page.dart'
    as seller_search;
import 'package:flutter_application_1/features/user_profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter_application_1/features/wishlists/presentation/pages/wishlist_page.dart';
import 'package:flutter_application_1/features/organization/presentation/pages/create_org_acc.dart';
import 'package:flutter_application_1/features/guest/presentation/pages/guest_page.dart';
import 'package:flutter_application_1/features/guest/presentation/pages/about_app_page.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/pages/my_custom_orders_page.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/pages/custom_order_detail_page.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/pages/seller_inbox_page.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/pages/quote_order_page.dart';
import 'package:flutter_application_1/features/image_generate/presentation/pages/image_generate_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_application_1/features/orders/presentation/pages/order_history/rate_order_page.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/order_history/rating_thank_you_page.dart';
import 'package:flutter_application_1/app/providers/shop_providers.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';

import '/features/forgot_password/presentation/pages/forgot_password_page.dart';
import '/features/forgot_password/presentation/pages/verify_otp_screen.dart';
import '/features/forgot_password/presentation/pages/new_password_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RegisterLogin()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    //************************************************************************ */
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) => const VerifyOTPScreen(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPasswordScreen(),
    ),

    //****************************************************************************** */
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/wallet', builder: (context, state) => const WalletPage()),
    GoRoute(path: '/ai-chat', builder: (context, state) => const AiChatPage()),
    GoRoute(
      path: '/image-generate',
      builder: (context, state) => const ImageGeneratePage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: '/seller/:storeId',
      builder: (context, state) {
        final storeId = state.pathParameters['storeId'] ?? '';
        return SellerEntryPage(storeId: storeId);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is WishlistRouteArgs) {
          return WishlistPage(
            wishlist: extra.wishlist,
            onRemove: extra.onRemove,
            onAddToCart: extra.onAddToCart,
            onRemoveFromCart: extra.onRemoveFromCart,
            cartItems: extra.cartItems,
            onToggleWishlist: extra.onToggleWishlist,
            onOpenCart: () => context.push('/cart'),
            onUpdateQuantity: extra.onUpdateQuantity,
          );
        }

        return Consumer(
          builder: (context, ref, _) {
            final shopController = ref.watch(shopControllerProvider);
            return WishlistPage(
              wishlist: shopController.wishlist,
              onRemove: shopController.removeFromWishlist,
              onAddToCart: shopController.addToCart,
              onRemoveFromCart: shopController.removeFromCart,
              cartItems: shopController.cartItems,
              onToggleWishlist: shopController.toggleWishlist,
              onOpenCart: () => context.push('/cart'),
              onUpdateQuantity: shopController.updateCartQuantity,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) {
        return const CartPage();
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final totalPrice = (state.extra is double)
            ? state.extra as double
            : 0.0;
        return CheckoutPage(totalPrice: totalPrice);
      },
    ),
    GoRoute(
      path: '/order-sent',
      builder: (context, state) => const cart_order_sent.OrderSent(),
    ),
    GoRoute(
      path: '/create-store-choice',
      builder: (context, state) => const StoreCreationChoicePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const UserProfilePage();
      },
    ),
    GoRoute(
      path: '/account-info',
      builder: (context, state) => const AccountInfoPage(),
    ),
    GoRoute(
      path: '/personal-info-edit',
      builder: (context, state) => const PersonalInfoEditPage(),
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => const PaymentMethodsPage(),
    ),

    GoRoute(
      path: '/store-seller',
      builder: (context, state) => const CreateStorePage(),
    ),
    GoRoute(
      path: '/store-dashboard',
      builder: (context, state) => const StoreDashboard(),
    ),
    GoRoute(
      path: '/seller-page',
      builder: (context, state) => const SellerPage(),
    ),

    GoRoute(
      path: '/seller-settings',
      builder: (context, state) => const SellerStoreSettingsPage(),
    ),

    /*  حذفناهاااااااااا 
   GoRoute(
      path: '/association-verification',
      builder: (context, state) => AssociationVerificationPage(),
    ),*/
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! ProductCardModel) {
          return const SizedBox.shrink();
        }
        return EditProductPage(product: extra);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        final args = state.extra;
        if (args is! EditProfilePageArgs) {
          return const SizedBox.shrink();
        }
        return provider.ChangeNotifierProvider.value(
          value: args.userController,
          child: EditProfilePage(user: args.user),
        );
      },
    ),
    // Organization Product Details Page
    GoRoute(
      path: '/org-product-details',
      builder: (context, state) {
        final args = state.extra;
        if (args is! OrgProductDetailsArgs) {
          return const SizedBox.shrink();
        }
        return ProductDetailsPage(
          product: args.product,
          isFavorite: args.isFavorite,
          onFavoriteToggle: args.onFavoriteToggle,
          associationName: args.associationName,
          associationId: args.associationId,
        );
      },
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final args = state.extra;
        if (args is! ProductDetailPageArgs) {
          return const SizedBox.shrink();
        }
        return ProductDetailPage(
          product: args.product,
          isFavorite: args.isFavorite,
          onFavoriteToggle: args.onFavoriteToggle,
          scrollController: args.scrollController,
        );
      },
    ),
    GoRoute(
      path: '/create-custom-order',
      builder: (context, state) {
        final args = state.extra;
        if (args is! CreateCustomOrderPageArgs) {
          return const SizedBox.shrink();
        }
        return CreateCustomOrderPage(
          sellerProfileId: args.sellerProfileId,
          sellerStoreName: args.sellerStoreName,
        );
      },
    ),
    GoRoute(
      path: '/seller-search',
      builder: (context, state) {
        final args = state.extra;
        if (args is! seller_search.SearchPageArgs) {
          return const SizedBox.shrink();
        }
        return seller_search.SearchPage(
          products: args.products,
          cartItems: args.cartItems,
          onUpdateQuantity: args.onUpdateQuantity,
          onOpenCart: args.onOpenCart,
          wishlist: args.wishlist,
          onToggleWishlist: args.onToggleWishlist,
        );
      },
    ),
    GoRoute(
      path: '/public-orders',
      builder: (context, state) => const PublicOrdersPage(),
    ),
    GoRoute(
      path: '/public-orders/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final canManage = state.extra == true;
        return PublicOrderDetailsPage(orderId: id, canManage: canManage);
      },
    ),
    GoRoute(
      path: '/edit-public-order/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return EditPublicOrderPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/create-public-order',
      builder: (context, state) {
        final extra = state.extra;
        return CreatePublicOrder(
          initialOrder: extra is PublicOrder ? extra : null,
        );
      },
    ),
    // ============ Custom Orders Routes ============
    GoRoute(
      path: '/my-custom-orders',
      builder: (context, state) => const MyCustomOrdersPage(),
    ),
    GoRoute(
      path: '/custom-order-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return CustomOrderDetailPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/seller-inbox',
      builder: (context, state) => const SellerInboxPage(),
    ),
    GoRoute(
      path: '/quote-order/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return QuoteOrderPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/crafts',
      builder: (context, state) =>
          const MarketsPage(title: 'متاجر الحرف', initialCategoryId: 2),
    ),
    GoRoute(
      path: '/food',
      builder: (context, state) =>
          const MarketsPage(title: 'متاجر الطعام', initialCategoryId: 1),
    ),
    GoRoute(
      path: '/organizations',
      builder: (context, state) => const OrganizationsCategoryPage(),
    ),
    GoRoute(
      path: '/organizations/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return OrganizationDetailsPage(organizationId: id);
      },
    ),
    GoRoute(
      path: '/organization',
      builder: (context, state) => const CreateOrgShopPage(),
    ),
    GoRoute(
      path: '/org-success',
      builder: (context, state) => const OrgApplicationSuccessPage(),
    ),
    // Organization Admin Routes
    GoRoute(
      path: '/organization-admin',
      builder: (context, state) => const AdminProductsScreen(),
    ),
    GoRoute(
      path: '/organization-admin/edit-info',
      builder: (context, state) => const EditOrganizationInfoScreen(),
    ),
    GoRoute(
      path: '/organization-admin/add-product',
      builder: (context, state) => const AddEditProductScreen(),
    ),
    GoRoute(
      path: '/organization-admin/edit-product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id'];
        return AddEditProductScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/store-success',
      builder: (context, state) => const StoreCreationSuccessPage(),
    ),
    GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),
    GoRoute(
      path: '/user-settings',
      builder: (context, state) => const UserSettingsPage(),
    ),
    GoRoute(
      path: '/guest-page',
      builder: (context, state) => const GuestPage(),
    ),
    GoRoute(
      path: '/about-app',
      builder: (context, state) => const AboutAppPage(),
    ),
    GoRoute(
      path: '/profile-settings',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          // Watch locale to trigger rebuild on language change
          ref.watch(localeProvider);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.profileSettings,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 83, 148, 93),
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFFAFBFA),
              elevation: 0,
            ),
            body: const ProfileSettingsSection(),
          );
        },
      ),
    ),

    GoRoute(
      path: '/language-settings',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          // Watch locale to trigger rebuild on language change
          ref.watch(localeProvider);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 83, 148, 93),
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFFAFBFA),
              elevation: 0,
            ),
            body: const LanguageSettingsSection(),
          );
        },
      ),
    ),
    GoRoute(
      path: '/password-settings',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          // Watch locale to trigger rebuild on language change
          ref.watch(localeProvider);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.password,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 83, 148, 93),
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFFAFBFA),
              elevation: 0,
            ),
            body: const PasswordSettingsSection(),
          );
        },
      ),
    ),

    GoRoute(
      path: '/past-orders',
      builder: (context, state) => const PastOrdersPage(),
    ),
    GoRoute(
      path: '/rate-order',
      builder: (context, state) {
        final orderId = state.extra as String;
        return RateOrderPage(orderId: orderId);
      },
    ),

    GoRoute(
      path: '/rating-thank-you',
      builder: (context, state) => const RatingThankYouPage(),
    ),
    GoRoute(
      path: '/season/:season',
      builder: (context, state) {
        final season = state.pathParameters['season']!;
        return SeasonStoresPage(season: season);
      },
    ),
    GoRoute(
      path: '/event/:eventId',
      builder: (context, state) {
        final eventIdStr = state.pathParameters['eventId'] ?? '0';
        final eventId = int.tryParse(eventIdStr) ?? 0;
        return EventDetailPage(eventId: eventId);
      },
    ),
  ],
);

/// Arguments for navigating to the Organization Product Details page.
@immutable
class OrgProductDetailsArgs {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final String? associationName;
  final String? associationId;

  const OrgProductDetailsArgs({
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.associationName,
    this.associationId,
  });
}
