class ForgotPasswordState {
  final String email;
  final String otp;
  final bool isLoading;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.otp = '',
    this.isLoading = false,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? otp,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
