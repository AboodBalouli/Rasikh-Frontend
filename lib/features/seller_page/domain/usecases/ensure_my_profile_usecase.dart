import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';

class EnsureMyProfileUseCase {
  final SellerRepository repository;

  EnsureMyProfileUseCase(this.repository);

  Future<SellerProfile> call() {
    return repository.ensureMyProfile();
  }
}
