import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateSellerCategory {
  final UserProfileRepository repository;

  UpdateSellerCategory(this.repository);

  Future<Profile> call({required int categoryId}) {
    return repository.updateSellerCategory(categoryId: categoryId);
  }
}
