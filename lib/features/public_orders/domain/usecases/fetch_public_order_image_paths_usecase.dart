import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class FetchPublicOrderImagePathsUseCase {
  final PublicOrdersRepository _repository;

  const FetchPublicOrderImagePathsUseCase(this._repository);

  Future<List<String>> call(String publicOrderId) {
    return _repository.fetchPublicOrderImagePaths(publicOrderId);
  }
}
