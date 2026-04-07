import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class FetchMyPublicOrdersUseCase {
  final PublicOrdersRepository _repository;

  const FetchMyPublicOrdersUseCase(this._repository);

  Future<List<PublicOrder>> call() => _repository.fetchMyPublicOrders();
}
