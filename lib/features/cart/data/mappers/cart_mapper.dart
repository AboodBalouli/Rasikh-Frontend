import 'package:flutter_application_1/features/cart/data/models/cart_item_response.dart';
import 'package:flutter_application_1/features/cart/data/models/cart_response.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';

CartItem mapCartItemResponseToCartItem(CartItemResponse response) {
  return CartItem(
    id: response.id,
    productId: response.productId,
    productName: response.productName,
    productDescription: response.productDescription,
    productPrice: response.productPrice.toDouble(),
    quantity: response.quantity,
    subtotal: response.subtotal.toDouble(),
    productImagePath: response.productImagePath ?? '',
    sellerProfileId: response.sellerProfileId,
    sellerFirstName: response.sellerFirstName,
    sellerLastName: response.sellerLastName,
  );
}

Cart mapCartResponseToCart(CartResponse response) {
  return Cart(
    items: response.items.map(mapCartItemResponseToCartItem).toList(growable: false),
    totalItems: response.totalItems,
    totalAmount: response.totalAmount.toDouble(),
  );
}
