import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';

class EnsureMyProfile {
  final UserProfileRepository repository;

  EnsureMyProfile(this.repository);

  Future<Profile> call() {
    return repository.ensureMyProfile();
  }
}
