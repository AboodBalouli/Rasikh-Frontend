import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_application_1/core/network/token_provider.dart';

class SecureStorageTokenProvider implements TokenProvider {
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  const SecureStorageTokenProvider({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }
}
