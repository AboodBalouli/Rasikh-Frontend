import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/auth/data/mappers/auth_session_mapper.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/core/network/auth_exception.dart';
import 'package:flutter_application_1/core/network/models/api_error.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final apiResponse = await _remote.login(email: email, password: password);

    if (apiResponse.success && apiResponse.data != null) {
      await _local.saveToken(apiResponse.data!.token);
      await _local.saveRole(apiResponse.data!.role);
      return mapAuthResponseToAuthSession(apiResponse.data!);
    }
    /**
 * success
 * data
 * error
 */
    final ApiError? error = apiResponse.error;
    final message = error?.message ?? 'Unknown error occurred';

    throw AuthException(message);
  }

  @override
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final apiResponse = await _remote.register(
      firstName,
      lastName,
      email,
      password,
    );

    if (apiResponse.success) {
      return true;
    }

    final ApiError? error = apiResponse.error;
    final message = error?.message ?? 'Unknown error occurred';

    throw AuthException(message);
  }

  @override
  Future<String?> getSavedToken() {
    return _local.getToken();
  }

  @override
  Future<void> logout() async {
    await _local.clearToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _local.getToken();
    return token != null;
  }
}
