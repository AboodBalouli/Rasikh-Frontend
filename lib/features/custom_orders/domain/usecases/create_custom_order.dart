import '../entities/custom_order.dart';
import '../repositories/custom_orders_repository.dart';

/// Use case for creating a new custom order request.
class CreateCustomOrder {
  final CustomOrdersRepository _repository;

  CreateCustomOrder(this._repository);

  Future<CustomOrder> call({
    required String sellerProfileId,
    required String title,
    required String description,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
    List<String>? imagePaths,
  }) {
    return _repository.createCustomOrder(
      sellerProfileId: sellerProfileId,
      title: title,
      description: description,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
      imagePaths: imagePaths,
    );
  }
}
