import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/remove_from_wishlist_usecase.dart';

import 'product_details_state.dart';

/// Controller for the Product Details screen.
/// Manages product loading, quantity selection, and wishlist interactions.
class ProductDetailsController extends StateNotifier<ProductDetailsState> {
  final GetProductByIdUsecase _getProductById;
  final AddToWishlistUseCase? _addToWishlist;
  final RemoveFromWishlistUseCase? _removeFromWishlist;

  ProductDetailsController({
    required GetProductByIdUsecase getProductById,
    AddToWishlistUseCase? addToWishlist,
    RemoveFromWishlistUseCase? removeFromWishlist,
  }) : _getProductById = getProductById,
       _addToWishlist = addToWishlist,
       _removeFromWishlist = removeFromWishlist,
       super(ProductDetailsState.initial());

  /// Load product details by ID.
  Future<void> loadProduct(String productId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final product = await _getProductById(productId);

      if (product == null) {
        state = state.copyWith(isLoading: false, error: 'المنتج غير موجود');
        return;
      }

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل بيانات المنتج',
      );
    }
  }

  /// Initialize the controller with a product that was passed from navigation.
  void initWithProduct(Product product, {bool isFavorite = false}) {
    state = state.copyWith(
      product: product,
      isFavorite: isFavorite,
      isLoading: false,
    );
  }

  /// Set the favorite state (from external wishlist data).
  void setFavorite(bool isFavorite) {
    state = state.copyWith(isFavorite: isFavorite);
  }

  /// Toggle wishlist/favorite status.
  Future<void> toggleFavorite() async {
    if (state.product == null) return;
    if (state.isTogglingFavorite) return;

    final wasInFavorite = state.isFavorite;

    // Optimistic update
    state = state.copyWith(
      isFavorite: !wasInFavorite,
      isTogglingFavorite: true,
    );

    try {
      final productId = state.product!.id;

      if (wasInFavorite) {
        // Remove from wishlist
        await _removeFromWishlist?.call(productId);
      } else {
        // Add to wishlist
        await _addToWishlist?.call(productId);
      }

      state = state.copyWith(isTogglingFavorite: false);
    } catch (e) {
      // Revert on error
      state = state.copyWith(
        isFavorite: wasInFavorite,
        isTogglingFavorite: false,
      );
    }
  }

  /// Set quantity to a specific value.
  void setQuantity(int quantity) {
    final clamped = quantity < 0 ? 0 : quantity;
    state = state.copyWith(quantity: clamped);
  }

  /// Increment quantity by 1.
  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  /// Decrement quantity by 1 (minimum 0).
  void decrementQuantity() {
    if (state.quantity > 0) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  /// Add to cart with current quantity.
  /// Returns true if quantity > 0, false otherwise.
  bool addToCart() {
    if (state.quantity == 0) {
      // First tap on "Add to Cart" button
      state = state.copyWith(quantity: 1);
      return true;
    }
    return state.quantity > 0;
  }

  /// Reset quantity to 0 (remove from local selection).
  void resetQuantity() {
    state = state.copyWith(quantity: 0);
  }
}
