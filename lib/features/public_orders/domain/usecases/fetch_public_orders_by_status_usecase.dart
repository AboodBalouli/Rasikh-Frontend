import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class FetchPublicOrdersByStatusUseCase {
  final PublicOrdersRepository _repository;

  const FetchPublicOrdersByStatusUseCase(this._repository);

  Future<List<PublicOrder>> call({
    required String status,
    required int pageNumber,
    int pageSize = 10,
  }) {
    return _repository.fetchPublicOrdersByStatus(
      status: status,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
