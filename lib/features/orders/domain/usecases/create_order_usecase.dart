import '../entities/create_order_request.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository _repository;
  const CreateOrderUseCase(this._repository);

  Future<Order> call(CreateOrderRequest request) {
    return _repository.createOrder(request);
  }
}
