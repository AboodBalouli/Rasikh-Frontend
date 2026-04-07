import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository _repository;
  const CancelOrderUseCase(this._repository);

  Future<Order> call(int orderId) {
    return _repository.cancelOrder(orderId);
  }
}
