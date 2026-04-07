import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class UpdatePublicOrderUseCase {
  final PublicOrdersRepository _repository;

  const UpdatePublicOrderUseCase(this._repository);

  Future<PublicOrder> call({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? location,
    String? phoneNumber,
    String? whatsappUrl,
  }) {
    return _repository.updatePublicOrder(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
    );
  }
}
