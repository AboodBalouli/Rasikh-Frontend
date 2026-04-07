import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUsecase {
  final CartRepository _repository;

  ClearCartUsecase(this._repository);

  Future<void> call() {
    return _repository.clearCart();
  }
}
