import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class FetchOrderByIdUseCase {
  final OrdersRepository _repository;
  const FetchOrderByIdUseCase(this._repository);

  Future<Order> call(int orderId) {
    return _repository.fetchOrderById(orderId);
  }
}
