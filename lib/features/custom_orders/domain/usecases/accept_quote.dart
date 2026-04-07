import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for accepting a seller's quote.
class AcceptQuote {
  final CustomOrdersRepository _repository;

  AcceptQuote(this._repository);

  Future<CustomOrder> call(String id) {
    return _repository.acceptQuote(id);
  }
}
