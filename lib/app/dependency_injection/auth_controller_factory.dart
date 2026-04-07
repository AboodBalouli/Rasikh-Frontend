import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/register_controller.dart';
import 'package:http/http.dart' as http;

class RegisterControllerFactory {
  static RegisterController create() {
    final client = http.Client();
    final remoteDataSource = AuthRemoteDataSource(
      baseUrl: AppConfig.apiBaseUrl,
      client: client,
    );
    final local = AuthLocalDataSource();
    final authRepository = AuthRepositoryImpl(
      remote: remoteDataSource,
      local: local,
    );

    final registerUsecase = RegisterUsecase(authRepository);
    final controller = RegisterController(registerUsecase);

    controller.initializeControllers();
    return controller;
  }
}
