class VerifyOtpUseCase {
  /// Backend validates OTP during `resetPassword`.
  ///
  /// This usecase exists only to keep OTP validation logic out of UI.
  Future<bool> call(String otp) async => otp.trim().isNotEmpty;
}
