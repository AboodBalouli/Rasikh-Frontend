import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class GetMyOrdersCountUseCase {
  final PublicOrdersRepository _repository;

  const GetMyOrdersCountUseCase(this._repository);

  Future<int> call() => _repository.getMyOrdersCount();
}
