import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<void> call() async {
    return await _repository.logout();
  }
}
