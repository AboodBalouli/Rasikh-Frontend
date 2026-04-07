import 'package:flutter_application_1/core/entities/product.dart';

abstract class WishlistRepository {
  Future<List<Product>> fetchMyWishlist();
  Future<Product> addToWishlist(String productId);
  Future<void> removeFromWishlist(String productId);
}
