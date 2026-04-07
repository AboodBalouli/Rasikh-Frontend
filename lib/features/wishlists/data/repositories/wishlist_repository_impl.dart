import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/wishlists/data/datasources/wishlist_remote_datasource.dart';
import 'package:flutter_application_1/features/wishlists/data/mappers/wishlist_product_mapper.dart';
import 'package:flutter_application_1/features/wishlists/domain/entities/wishlist_exception.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDatasource remote;
  final TokenProvider tokenProvider;

  WishlistRepositoryImpl({required this.remote, required this.tokenProvider});

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const WishlistException('Not authenticated. Please login again');
    }
    return token;
  }

  @override
  Future<List<Product>> fetchMyWishlist() async {
    final apiResponse = await remote.getMyWishlist(
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!
          .map(mapWishlistProductResponseToProduct)
          .toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw WishlistException(message);
  }

  @override
  Future<Product> addToWishlist(String productId) async {
    final apiResponse = await remote.addToWishlist(
      productId: productId,
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapWishlistProductResponseToProduct(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw WishlistException(message);
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    final apiResponse = await remote.removeFromWishlist(
      productId: productId,
      token: await _requireToken(),
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw WishlistException(message);
  }
}
