import '../../domain/entities/forgot_password_entities.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_datasource.dart';
import '../models/request_password_reset_otp_request_model.dart';
import '../models/reset_password_request_model.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remote;
  ForgotPasswordRepositoryImpl(this.remote);

  @override
  Future<void> requestResetOtp(String email) async {
    await remote.requestResetOtp(RequestPasswordResetOtpRequestModel(email: email));
  }

  @override
  Future<void> resetPassword(ResetPasswordEntity entity) async {
    await remote.resetPassword(ResetPasswordRequestModel(
      email: entity.email,
      otp: entity.otp,
      newPassword: entity.newPassword,
    ));
  }
}
