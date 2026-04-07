import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsCountUsecase {
  final CartRepository _repository;

  GetCartItemsCountUsecase(this._repository);

  Future<int> call() {
    return _repository.getCartItemsCount();
  }
}
