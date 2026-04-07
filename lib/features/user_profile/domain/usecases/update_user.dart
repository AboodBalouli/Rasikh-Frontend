import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';
import '../entities/user.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<User> call(User user) {
    return repository.updateUser(user);
  }
}
