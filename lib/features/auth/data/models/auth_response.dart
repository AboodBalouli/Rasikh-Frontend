class AuthResponse {
  final String token;
  final int expiresIn;
  final String? role;

  AuthResponse({required this.token, required this.expiresIn, this.role});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {

    return AuthResponse(
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
      role: json['role'] as String?,
    );
  }
}
