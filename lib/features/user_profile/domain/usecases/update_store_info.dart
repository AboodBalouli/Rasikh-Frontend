import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateStoreInfo {
  final UserProfileRepository repository;

  UpdateStoreInfo(this.repository);

  Future<Profile> call(StoreInfo storeInfo) {
    return repository.updateStoreInfo(storeInfo);
  }
}
