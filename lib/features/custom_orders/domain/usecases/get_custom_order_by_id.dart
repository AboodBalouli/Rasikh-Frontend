import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for getting a custom order by ID.
class GetCustomOrderById {
  final CustomOrdersRepository _repository;

  GetCustomOrderById(this._repository);

  Future<CustomOrder> call(String id) {
    return _repository.getCustomOrderById(id);
  }
}
