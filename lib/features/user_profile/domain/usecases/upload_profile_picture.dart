import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:flutter/foundation.dart' show Uint8List;

class UploadProfilePicture {
  final UserProfileRepository repository;

  UploadProfilePicture(this.repository);

  /// Uploads/overwrites the profile picture by userId.
  /// Backend returns a relative path like: "images/profile/<uuid>.<ext>".
  Future<String> call({
    required int userId,
    String? filePath,
    Uint8List? bytes,
    String? filename,
  }) {
    return repository.uploadProfilePicture(
      userId: userId,
      filePath: filePath,
      bytes: bytes,
      filename: filename,
    );
  }
}
