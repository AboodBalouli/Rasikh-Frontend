import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class RemoveItemFromCartUsecase {
  final CartRepository _repository;

  RemoveItemFromCartUsecase(this._repository);

  Future<void> call({required int cartItemId}) {
    return _repository.removeItemFromCart(cartItemId: cartItemId);
  }
}
