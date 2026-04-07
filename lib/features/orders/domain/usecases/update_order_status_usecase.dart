import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase {
  final OrdersRepository _repository;
  const UpdateOrderStatusUseCase(this._repository);

  Future<Order> call({required int orderId, required OrderStatus newStatus}) {
    return _repository.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
    );
  }
}
