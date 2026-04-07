import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';

class GetMyProfileUseCase {
  final SellerRepository repository;

  GetMyProfileUseCase(this.repository);

  Future<SellerProfile> call() {
    return repository.getMyProfile();
  }
}
