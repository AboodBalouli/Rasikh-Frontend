import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';

class UpdateSellerCategoryUseCase {
  final SellerRepository repository;

  UpdateSellerCategoryUseCase(this.repository);

  Future<SellerProfile> call(int categoryId) {
    return repository.updateSellerCategory(categoryId);
  }
}
