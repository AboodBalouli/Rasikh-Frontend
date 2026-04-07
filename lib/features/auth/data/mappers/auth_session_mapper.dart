import 'package:flutter_application_1/features/auth/data/models/auth_response.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_session.dart';

AuthSession mapAuthResponseToAuthSession(AuthResponse model) {
  return AuthSession(
    token: model.token,
    expiresIn: model.expiresIn,
    role: model.role,
  );
}
