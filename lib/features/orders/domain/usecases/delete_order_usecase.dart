import '../repositories/orders_repository.dart';

class DeleteOrderUseCase {
  final OrdersRepository _repository;
  const DeleteOrderUseCase(this._repository);

  Future<void> call(int orderId) {
    return _repository.deleteOrder(orderId);
  }
}
