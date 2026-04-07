import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class GetMyCartUsecase {
  final CartRepository _repository;

  GetMyCartUsecase(this._repository);

  Future<Cart> call() {
    return _repository.getMyCart();
  }
}
