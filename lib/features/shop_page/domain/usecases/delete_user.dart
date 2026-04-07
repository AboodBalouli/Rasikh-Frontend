import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String id) {
    return repository.deleteUser(id);
  }
}
