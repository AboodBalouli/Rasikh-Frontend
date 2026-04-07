class AuthSession {
  final String token;
  final int expiresIn;
  final String? role;

  const AuthSession({required this.token, required this.expiresIn, this.role});
}
