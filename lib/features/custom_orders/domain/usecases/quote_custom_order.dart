import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for seller to quote a custom order request.
class QuoteCustomOrder {
  final CustomOrdersRepository _repository;

  QuoteCustomOrder(this._repository);

  Future<CustomOrder> call({
    required String id,
    required double quotedPrice,
    required int estimatedDays,
    String? sellerNote,
  }) {
    return _repository.quoteCustomOrder(
      id: id,
      quotedPrice: quotedPrice,
      estimatedDays: estimatedDays,
      sellerNote: sellerNote,
    );
  }
}
