class RequestPasswordResetOtpRequestModel {
  final String email;

  RequestPasswordResetOtpRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
