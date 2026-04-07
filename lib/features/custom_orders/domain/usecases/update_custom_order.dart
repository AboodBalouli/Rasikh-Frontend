import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for updating a custom order (only when PENDING).
class UpdateCustomOrder {
  final CustomOrdersRepository _repository;

  UpdateCustomOrder(this._repository);

  Future<CustomOrder> call({
    required String id,
    String? title,
    String? description,
    String? location,
  }) {
    return _repository.updateCustomOrder(
      id: id,
      title: title,
      description: description,
      location: location,
    );
  }
}
