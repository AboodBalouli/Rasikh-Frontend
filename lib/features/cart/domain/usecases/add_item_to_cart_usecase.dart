import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class AddItemToCartUsecase {
  final CartRepository _repository;

  AddItemToCartUsecase(this._repository);

  Future<CartItem> call({required int productId, required int quantity}) {
    return _repository.addItemToCart(productId: productId, quantity: quantity);
  }
}
