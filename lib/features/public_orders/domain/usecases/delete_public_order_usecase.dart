import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class DeletePublicOrderUseCase {
  final PublicOrdersRepository _repository;

  const DeletePublicOrderUseCase(this._repository);

  Future<void> call(String id) => _repository.deletePublicOrder(id);
}
