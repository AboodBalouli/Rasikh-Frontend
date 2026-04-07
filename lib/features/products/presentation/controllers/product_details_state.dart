import 'package:flutter_application_1/core/entities/product.dart';

/// Immutable state for the Product Details screen.
class ProductDetailsState {
  /// Whether we are loading the product.
  final bool isLoading;

  /// Error message if loading failed.
  final String? error;

  /// The loaded product details.
  final Product? product;

  /// Current quantity selected by the user (local state, not yet in cart).
  final int quantity;

  /// Whether the product is in the user's wishlist.
  final bool isFavorite;

  /// Whether we are performing a wishlist action.
  final bool isTogglingFavorite;

  /// Whether we are adding to cart.
  final bool isAddingToCart;

  const ProductDetailsState({
    this.isLoading = false,
    this.error,
    this.product,
    this.quantity = 0,
    this.isFavorite = false,
    this.isTogglingFavorite = false,
    this.isAddingToCart = false,
  });

  /// Initial state before any data is loaded.
  factory ProductDetailsState.initial() => const ProductDetailsState();

  /// Copy with method for immutable state updates.
  ProductDetailsState copyWith({
    bool? isLoading,
    String? error,
    Product? product,
    int? quantity,
    bool? isFavorite,
    bool? isTogglingFavorite,
    bool? isAddingToCart,
    bool clearError = false,
    bool clearProduct = false,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      product: clearProduct ? null : (product ?? this.product),
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isTogglingFavorite: isTogglingFavorite ?? this.isTogglingFavorite,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }

  /// Computed total price based on quantity.
  double get totalPrice => (product?.price ?? 0) * (quantity > 0 ? quantity : 1);
}
