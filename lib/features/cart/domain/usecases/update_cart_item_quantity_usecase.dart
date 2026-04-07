import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItemQuantityUsecase {
  final CartRepository _repository;

  UpdateCartItemQuantityUsecase(this._repository);

  Future<void> call({required int quantity, required int cartItemId}) {
    return _repository.updateCartItemQuantity(
      quantity: quantity,
      cartItemId: cartItemId,
    );
  }
}
