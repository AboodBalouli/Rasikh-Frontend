import '../entities/forgot_password_entities.dart';
import '../repositories/forgot_password_repository.dart';

class ResetPasswordUseCase {
  final ForgotPasswordRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<void> call(ResetPasswordEntity entity) async =>
      repository.resetPassword(entity);
}
