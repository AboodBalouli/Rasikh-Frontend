import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(authHttpClientProvider);
  return AuthRemoteDataSource(baseUrl: AppConfig.apiBaseUrl, client: client);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(remote: remote, local: local);
});
