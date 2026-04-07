// This is what the UI / controllers will depend on — not on HTTP.

import 'package:flutter_application_1/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({required String email, required String password});

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<String?> getSavedToken();

  Future<void> logout();

  Future<bool> isLoggedIn();
}
