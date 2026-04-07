import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';

class FetchMyWishlistUseCase {
  final WishlistRepository repository;
  FetchMyWishlistUseCase(this.repository);

  Future<List<Product>> call() => repository.fetchMyWishlist();
}
