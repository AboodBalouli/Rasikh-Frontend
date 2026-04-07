class LoginState {
  final bool isLoading;
  final bool isPasswordObscured;
  final bool isFormValid;

  const LoginState({
    required this.isLoading,
    required this.isPasswordObscured,
    required this.isFormValid,
  });

  factory LoginState.initial() => const LoginState(
    isLoading: false,
    isPasswordObscured: true, // same as your passwordNotifier = true
    isFormValid: false,
  );

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordObscured,
    bool? isFormValid,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
