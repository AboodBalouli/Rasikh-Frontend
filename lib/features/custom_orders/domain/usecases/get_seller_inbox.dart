import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for getting seller's inbox (custom order requests).
class GetSellerInbox {
  final CustomOrdersRepository _repository;

  GetSellerInbox(this._repository);

  Future<List<CustomOrder>> call() {
    return _repository.getSellerInbox();
  }
}
