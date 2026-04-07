import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class FetchPublicOrdersUseCase {
  final PublicOrdersRepository _repository;

  const FetchPublicOrdersUseCase(this._repository);

  Future<List<PublicOrder>> call({required int pageNumber, int pageSize = 10}) {
    return _repository.fetchPublicOrders(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
