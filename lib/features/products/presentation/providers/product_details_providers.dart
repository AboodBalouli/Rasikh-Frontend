import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;

import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:flutter_application_1/features/products/presentation/controllers/product_details_controller.dart';
import 'package:flutter_application_1/features/products/presentation/controllers/product_details_state.dart';
import 'package:flutter_application_1/features/products/presentation/providers/single_product_provider.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/presentation/providers/wishlist_providers.dart';

/// Provider for the GetProductByIdUsecase.
final getProductByIdUsecaseProvider = Provider<GetProductByIdUsecase>((ref) {
  final repo = ref.read(singleProductRepositoryProvider);
  return GetProductByIdUsecase(repo);
});

/// Provider for the ProductDetailsController.
/// 
/// This provider manages the state for a single product details screen.
/// It is auto-disposed when no longer needed.
final productDetailsControllerProvider = legacy.StateNotifierProvider
    .autoDispose<ProductDetailsController, ProductDetailsState>((ref) {
  final getProductById = ref.watch(getProductByIdUsecaseProvider);
  
  // Wishlist use cases (optional - for toggling favorites)
  AddToWishlistUseCase? addToWishlist;
  RemoveFromWishlistUseCase? removeFromWishlist;
  
  try {
    addToWishlist = ref.watch(addToWishlistUseCaseProvider);
    removeFromWishlist = ref.watch(removeFromWishlistUseCaseProvider);
  } catch (_) {
    // Wishlist providers may not be available in all cases
  }

  return ProductDetailsController(
    getProductById: getProductById,
    addToWishlist: addToWishlist,
    removeFromWishlist: removeFromWishlist,
  );
});

/// Convenient provider to access just the product from details state.
final productDetailsProductProvider = Provider.autoDispose<Product?>((ref) {
  final state = ref.watch(productDetailsControllerProvider);
  return state.product;
});

/// Convenient provider to check if product is loading.
final productDetailsIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(productDetailsControllerProvider);
  return state.isLoading;
});

/// Convenient provider to get the current quantity.
final productDetailsQuantityProvider = Provider.autoDispose<int>((ref) {
  final state = ref.watch(productDetailsControllerProvider);
  return state.quantity;
});

/// Convenient provider to check if product is favorite.
final productDetailsIsFavoriteProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(productDetailsControllerProvider);
  return state.isFavorite;
});
