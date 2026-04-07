import '../entities/cart.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Cart> getMyCart();

  Future<CartItem> addItemToCart({
    required int productId,
    required int quantity,
  });

  Future<void> updateCartItemQuantity({
    required int quantity,
    required int cartItemId,
  });

  Future<void> removeItemFromCart({required int cartItemId});

  Future<void> clearCart();

  Future<int>
  getCartItemsCount(); //Note: This returns the number of `CartItem` rows, not the sum of quantities.
}
