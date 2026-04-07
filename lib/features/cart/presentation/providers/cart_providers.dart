import 'package:flutter_application_1/app/dependency_injection/cart_dependency_injection.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/add_item_to_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/get_cart_items_count_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/get_my_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/remove_item_from_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;

import 'package:flutter_application_1/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_application_1/features/cart/presentation/controllers/cart_state.dart';

final getMyCartUseCaseProvider = Provider<GetMyCartUsecase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return GetMyCartUsecase(repo);
});

final addItemToCartUseCaseProvider = Provider<AddItemToCartUsecase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return AddItemToCartUsecase(repo);
});

final updateCartItemQuantityUseCaseProvider =
    Provider<UpdateCartItemQuantityUsecase>((ref) {
      final repo = ref.watch(cartRepositoryProvider);
      return UpdateCartItemQuantityUsecase(repo);
    });

final removeItemFromCartUseCaseProvider = Provider<RemoveItemFromCartUsecase>((
  ref,
) {
  final repo = ref.watch(cartRepositoryProvider);
  return RemoveItemFromCartUsecase(repo);
});

final clearCartUseCaseProvider = Provider<ClearCartUsecase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return ClearCartUsecase(repo);
});

final getCartItemsCountUseCaseProvider = Provider<GetCartItemsCountUsecase>((
  ref,
) {
  final repo = ref.watch(cartRepositoryProvider);
  return GetCartItemsCountUsecase(repo);
});

/// Fetch current authenticated user's cart.
final myCartProvider = FutureProvider<Cart>((ref) async {
  final usecase = ref.watch(getMyCartUseCaseProvider);
  return usecase();
});

/// Fetch number of cart item rows (NOT sum of quantities).
final cartItemsCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getCartItemsCountUseCaseProvider);
  return usecase();
});

/// Action provider: add item to cart and return the affected line.
final addItemToCartProvider =
    FutureProvider.family<CartItem, ({int productId, int quantity})>((
      ref,
      params,
    ) async {
      final usecase = ref.watch(addItemToCartUseCaseProvider);
      return usecase(productId: params.productId, quantity: params.quantity);
    });

final cartControllerProvider =
    legacy.StateNotifierProvider.autoDispose<CartController, CartState>((ref) {
      final getMyCart = ref.watch(getMyCartUseCaseProvider);
      final addItem = ref.watch(addItemToCartUseCaseProvider);
      final updateQty = ref.watch(updateCartItemQuantityUseCaseProvider);
      final removeItem = ref.watch(removeItemFromCartUseCaseProvider);
      final clearCart = ref.watch(clearCartUseCaseProvider);

      final controller = CartController(
        getMyCart,
        addItem,
        updateQty,
        removeItem,
        clearCart,
      );

      controller.loadCart();
      return controller;
    });

/// Sum of quantities across all cart lines (use for badges).
///
/// Includes optimistic quantities (including products not yet in cart list).
final cartTotalQuantityProvider = Provider<int>((ref) {
  final state = ref.watch(cartControllerProvider);
  final cart = state.cart;
  final items = cart?.items ?? const <CartItem>[];

  final productIdsInCart = <int>{};
  var total = 0;
  for (final item in items) {
    productIdsInCart.add(item.productId);
    total += item.quantity;
  }

  // Add optimistic quantities for products not present in the cart yet.
  state.optimisticQuantityByProductId.forEach((productId, qty) {
    if (!productIdsInCart.contains(productId) && qty > 0) {
      total += qty;
    }
  });

  return total;
});

/// Get the seller ID of the current cart items (null if cart is empty).
/// Used to check if new products are from a different seller.
final currentCartSellerIdProvider = Provider<int?>((ref) {
  final state = ref.watch(cartControllerProvider);
  return state.currentCartSellerId;
});

/// Current quantity in cart for a given [productId] (string id from Product).
///
/// Returns optimistic value immediately if there is a pending override.
final cartQuantityForProductIdProvider = Provider.family<int, String>((
  ref,
  productId,
) {
  final parsed = int.tryParse(productId);
  if (parsed == null) return 0;

  final state = ref.watch(cartControllerProvider);

  final optimistic = state.optimisticQuantityByProductId[parsed];
  if (optimistic != null) return optimistic;

  final cart = state.cart;
  final items = cart?.items ?? const <CartItem>[];
  for (final item in items) {
    if (item.productId == parsed) return item.quantity;
  }
  return 0;
});

/// Cart line for a given [productId] (string id from Product), if it exists.
///
/// Uses the optimistic cart state.
final cartItemForProductIdProvider = Provider.family<CartItem?, String>((
  ref,
  productId,
) {
  final parsed = int.tryParse(productId);
  if (parsed == null) return null;
  final cart = ref.watch(cartControllerProvider).cart;
  final items = cart?.items ?? const <CartItem>[];
  for (final item in items) {
    if (item.productId == parsed) return item;
  }
  return null;
});
