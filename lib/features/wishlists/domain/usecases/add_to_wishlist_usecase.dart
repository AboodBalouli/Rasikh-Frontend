import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;
  AddToWishlistUseCase(this.repository);

  Future<Product> call(String productId) => repository.addToWishlist(productId);
}
