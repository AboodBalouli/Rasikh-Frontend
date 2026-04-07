import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for canceling a custom order.
class CancelCustomOrder {
  final CustomOrdersRepository _repository;

  CancelCustomOrder(this._repository);

  Future<CustomOrder> call(String id) {
    return _repository.cancelCustomOrder(id);
  }
}
