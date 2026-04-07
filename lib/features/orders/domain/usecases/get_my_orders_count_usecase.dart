import '../repositories/orders_repository.dart';

class GetMyOrdersCountUseCase {
  final OrdersRepository _repository;
  const GetMyOrdersCountUseCase(this._repository);

  Future<int> call() {
    return _repository.getMyOrdersCount();
  }
}
