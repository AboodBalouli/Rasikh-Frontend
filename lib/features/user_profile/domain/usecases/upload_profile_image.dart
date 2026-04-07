import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';

class UploadProfileImage {
  final UserRepository repository;

  UploadProfileImage(this.repository);

  Future<String> call(String userId, String imagePath) {
    return repository.uploadProfileImage(userId, imagePath);
  }
}
