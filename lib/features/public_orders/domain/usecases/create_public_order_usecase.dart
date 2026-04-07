import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class CreatePublicOrderUseCase {
  final PublicOrdersRepository _repository;

  const CreatePublicOrderUseCase(this._repository);

  Future<PublicOrder> call(PublicOrder order) {
    return _repository.createPublicOrder(order);
  }
}
