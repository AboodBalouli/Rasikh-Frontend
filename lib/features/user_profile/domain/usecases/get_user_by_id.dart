import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';
import '../entities/user.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<User> call(String id) {
    return repository.getUserById(id);
  }
}
