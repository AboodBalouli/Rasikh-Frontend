import '../repositories/forgot_password_repository.dart';

class RequestResetOtpUseCase {
  final ForgotPasswordRepository repository;
  RequestResetOtpUseCase(this.repository);

  Future<void> call(String email) async => repository.requestResetOtp(email);
}
