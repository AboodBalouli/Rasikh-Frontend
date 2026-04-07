import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class UploadPublicOrderImagesUseCase {
  final PublicOrdersRepository _repository;

  const UploadPublicOrderImagesUseCase(this._repository);

  Future<void> call({
    required String publicOrderId,
    required List<String> filePaths,
  }) {
    return _repository.uploadPublicOrderImages(
      publicOrderId: publicOrderId,
      filePaths: filePaths,
    );
  }
}
