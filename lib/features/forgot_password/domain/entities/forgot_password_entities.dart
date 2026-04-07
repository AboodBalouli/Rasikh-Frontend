class OtpVerification {
  final String email;
  final String code;
  OtpVerification({required this.email, required this.code});
}

class ResetPasswordEntity {
  final String email;
  final String otp;
  final String newPassword;
  
  ResetPasswordEntity({
    required this.email, 
    required this.otp, 
    required this.newPassword
  });
}
