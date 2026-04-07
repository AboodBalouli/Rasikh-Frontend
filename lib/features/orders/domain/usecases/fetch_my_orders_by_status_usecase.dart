import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repositories/orders_repository.dart';

class FetchMyOrdersByStatusUseCase {
  final OrdersRepository _repository;
  const FetchMyOrdersByStatusUseCase(this._repository);

  Future<List<Order>> call(OrderStatus status) {
    return _repository.fetchMyOrdersByStatus(status);
  }
}
