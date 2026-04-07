import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for seller to reject a custom order request.
class RejectCustomOrder {
  final CustomOrdersRepository _repository;

  RejectCustomOrder(this._repository);

  Future<CustomOrder> call(String id) {
    return _repository.rejectCustomOrder(id);
  }
}
