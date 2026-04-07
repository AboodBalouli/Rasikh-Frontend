import 'package:flutter_application_1/app/controllers/shop_controller.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/storage/secure_storage_token_provider.dart';
import 'package:flutter_application_1/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:flutter_application_1/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutter_application_1/features/shop_page/data/datasources/product_remote_datasource.dart';
import 'package:flutter_application_1/features/shop_page/data/repositories/product_repository_impl.dart';
import 'package:flutter_application_1/features/wishlists/data/datasources/wishlist_remote_datasource.dart';
import 'package:flutter_application_1/features/wishlists/data/repositories/wishlist_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;
import 'package:http/http.dart' as http;

final _productHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final _cartHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final _wishlistHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final productRepositoryProvider = Provider<ProductRepositoryImpl>((ref) {
  final remote = ProductRemoteDatasource(
    AppConfig.apiBaseUrl,
    client: ref.watch(_productHttpClientProvider),
  );
  return ProductRepositoryImpl(remote);
});

final cartRepositoryProvider = Provider<CartRepositoryImpl>((ref) {
  final remote = CartRemoteDatasource(
    client: ref.watch(_cartHttpClientProvider),
  );
  return CartRepositoryImpl(
    remote: remote,
    tokenProvider: const SecureStorageTokenProvider(),
  );
});

final wishlistRepositoryProvider = Provider<WishlistRepositoryImpl>((ref) {
  final remote = WishlistRemoteDatasource(
    client: ref.watch(_wishlistHttpClientProvider),
  );
  return WishlistRepositoryImpl(
    remote: remote,
    tokenProvider: const SecureStorageTokenProvider(),
  );
});

final shopControllerProvider = legacy.ChangeNotifierProvider<ShopController>((
  ref,
) {
  final controller = ShopController(
    ref.watch(productRepositoryProvider),
    ref.watch(cartRepositoryProvider),
    ref.watch(wishlistRepositoryProvider),
  );

  // Kick off initial loads once when the controller is created.
  controller
    ..loadProducts()
    ..refreshCart()
    ..refreshWishlist();

  return controller;
});
