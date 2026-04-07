import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for getting customer's own custom orders.
class GetMyCustomOrders {
  final CustomOrdersRepository _repository;

  GetMyCustomOrders(this._repository);

  Future<List<CustomOrder>> call() {
    return _repository.getMyCustomOrders();
  }
}
