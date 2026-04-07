import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:flutter_application_1/features/cart/data/mappers/cart_mapper.dart';
import 'package:flutter_application_1/features/cart/data/models/add_cart_item_request.dart';
import 'package:flutter_application_1/features/cart/data/models/update_cart_item_quantity_request.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_exception.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource remote;
  final TokenProvider tokenProvider;

  CartRepositoryImpl({required this.remote, required this.tokenProvider});

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const CartException('Not authenticated. Please login again');
    }
    return token;
  }

  @override
  Future<Cart> getMyCart() async {
    final apiResponse = await remote.getMyCart(token: await _requireToken());
    if (apiResponse.success && apiResponse.data != null) {
      return mapCartResponseToCart(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }

  @override
  Future<CartItem> addItemToCart({
    required int productId,
    required int quantity,
  }) async {
    final req = AddCartItemRequest(productId: productId, quantity: quantity);
    final apiResponse = await remote.addItemToCart(
      request: req,
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapCartItemResponseToCartItem(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }

  @override
  Future<void> updateCartItemQuantity({
    required int quantity,
    required int cartItemId,
  }) async {
    final update = UpdateCartItemQuantityRequest(quantity: quantity);
    final apiResponse = await remote.updateCartItemQuantity(
      cartItemId: cartItemId,
      update: update,
      token: await _requireToken(),
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }

  @override
  Future<void> removeItemFromCart({required int cartItemId}) async {
    final apiResponse = await remote.removeItemFromCart(
      cartItemId: cartItemId,
      token: await _requireToken(),
    );
    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }

  @override
  Future<void> clearCart() async {
    final apiResponse = await remote.clearCart(token: await _requireToken());
    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }

  @override
  Future<int> getCartItemsCount() async {
    final apiResponse = await remote.getCartItemsCount(
      token: await _requireToken(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw CartException(message);
  }
}
