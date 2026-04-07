import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

/// Use case to upload profile picture by userId
/// This calls endpoint 6 from images.md: POST /images/profile/user/{userId}
class UploadProfilePictureUseCase {
  final OrganizationRepository repository;

  UploadProfilePictureUseCase(this.repository);

  /// Uploads a profile picture for the given userId
  /// Returns the image path on success
  Future<String> call({required int userId, required Uint8List fileBytes}) {
    return repository.uploadProfilePictureByUserId(
      userId: userId,
      fileBytes: fileBytes,
    );
  }
}
