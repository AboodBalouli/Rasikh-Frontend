import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class FetchMyOrdersUseCase {
  final OrdersRepository _repository;
  const FetchMyOrdersUseCase(this._repository);

  Future<List<Order>> call() {
    return _repository.fetchMyOrders();
  }
}
