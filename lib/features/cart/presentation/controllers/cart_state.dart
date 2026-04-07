import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';

class CartState {
  final bool isLoading;

  /// Latest cart confirmed by backend.
  final Cart? confirmedCart;

  /// Cart used for UI rendering. This may include optimistic updates.
  final Cart? cart;

  /// Pending optimistic quantity overrides keyed by productId.
  final Map<int, int> optimisticQuantityByProductId;

  /// Product ids that have a pending debounced update.
  final Set<int> pendingProductIds;

  /// Cart item ids that are currently being mutated (update/remove).
  final Set<int> updatingCartItemIds;

  /// Last user-visible error message (if any).
  final String? errorMessage;

  const CartState({
    required this.isLoading,
    required this.confirmedCart,
    required this.cart,
    required this.optimisticQuantityByProductId,
    required this.pendingProductIds,
    required this.updatingCartItemIds,
    required this.errorMessage,
  });

  factory CartState.initial() => const CartState(
    isLoading: false,
    confirmedCart: null,
    cart: null,
    optimisticQuantityByProductId: <int, int>{},
    pendingProductIds: <int>{},
    updatingCartItemIds: <int>{},
    errorMessage: null,
  );

  static const Object _unset = Object();

  bool get hasPendingUpdates =>
      updatingCartItemIds.isNotEmpty || pendingProductIds.isNotEmpty;

  /// Get the seller ID of the current cart items (null if cart is empty).
  /// All items in the cart should be from the same seller.
  int? get currentCartSellerId {
    final items = cart?.items;
    if (items == null || items.isEmpty) return null;
    return items.first.sellerProfileId;
  }

  CartState copyWith({
    bool? isLoading,
    Cart? confirmedCart,
    Cart? cart,
    Map<int, int>? optimisticQuantityByProductId,
    Set<int>? pendingProductIds,
    Set<int>? updatingCartItemIds,
    Object? errorMessage = _unset,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      confirmedCart: confirmedCart ?? this.confirmedCart,
      cart: cart ?? this.cart,
      optimisticQuantityByProductId:
          optimisticQuantityByProductId ?? this.optimisticQuantityByProductId,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
      updatingCartItemIds: updatingCartItemIds ?? this.updatingCartItemIds,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
