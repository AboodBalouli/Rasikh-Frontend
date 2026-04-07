import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class FetchPublicOrderByIdUseCase {
  final PublicOrdersRepository _repository;

  const FetchPublicOrderByIdUseCase(this._repository);

  Future<PublicOrder> call(String id) => _repository.fetchPublicOrderById(id);
}
