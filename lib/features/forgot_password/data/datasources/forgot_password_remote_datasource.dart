import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/request_password_reset_otp_request_model.dart';
import '../models/reset_password_request_model.dart';

class ForgotPasswordRemoteDataSource {
  final ApiService _apiService;

  ForgotPasswordRemoteDataSource(this._apiService);

  Future<void> requestResetOtp(
    RequestPasswordResetOtpRequestModel request,
  ) async {
    debugPrint(
      'ForgotPasswordRemoteDataSource.requestResetOtp -> ${ApiEndpoints.requestPasswordReset} (email=${request.email})',
    );

    final response = await _apiService.post(
      ApiEndpoints.requestPasswordReset,
      request.toJson(),
    );

    if (response != null && response['success'] == false) {
      throw Exception(response['error']?['message'] ?? 'Failed to request OTP');
    }
  }

  Future<void> resetPassword(ResetPasswordRequestModel request) async {
    debugPrint(
      'ForgotPasswordRemoteDataSource.resetPassword -> ${ApiEndpoints.resetPassword} (email=${request.email}, otpLen=${request.otp.length})',
    );

    final response = await _apiService.post(
      ApiEndpoints.resetPassword,
      request.toJson(),
    );

    if (response != null && response['success'] == false) {
      throw Exception(
        response['error']?['message'] ?? 'Failed to reset password',
      );
    }
  }
}
