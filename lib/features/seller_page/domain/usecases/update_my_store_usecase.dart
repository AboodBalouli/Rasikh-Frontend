import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/update_store_info.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';

class UpdateMyStoreUseCase {
  final SellerRepository repository;

  UpdateMyStoreUseCase(this.repository);

  Future<SellerProfile> call(UpdateStoreInfo info) {
    return repository.updateStoreInfo(info);
  }
}
