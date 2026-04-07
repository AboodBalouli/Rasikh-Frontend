import '../entities/forgot_password_entities.dart';

abstract class ForgotPasswordRepository {
  Future<void> requestResetOtp(String email);
  Future<void> resetPassword(ResetPasswordEntity entity);
}
