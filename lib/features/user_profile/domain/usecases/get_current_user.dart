import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';
import '../entities/user.dart';

class GetCurrentUser {
  final UserRepository repository;

  GetCurrentUser(this.repository);

  Future<User> call() {
    return repository.getCurrentUser();
  }
}
