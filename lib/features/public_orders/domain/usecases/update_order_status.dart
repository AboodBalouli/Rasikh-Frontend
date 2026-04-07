import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';

class UpdatePublicOrderStatusUseCase {
	final PublicOrdersRepository _repository;

	const UpdatePublicOrderStatusUseCase(this._repository);

	Future<PublicOrder> call({required String id, required String status}) {
		return _repository.updatePublicOrderStatus(id: id, status: status);
	}
}

