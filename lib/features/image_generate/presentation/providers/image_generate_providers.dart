import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/image_generate_remote_datasource.dart';
import '../../data/repositories/image_generate_repository_impl.dart';
import '../../domain/repositories/image_generate_repository.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../controllers/image_generate_controller.dart';

/// Provider for the API service used by image generation.
final _imageGenApiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: AppConfig.chatbotBaseUrl);
});

/// Provider for the remote datasource.
final _imageGenRemoteDatasourceProvider =
    Provider<ImageGenerateRemoteDatasource>((ref) {
      return ImageGenerateRemoteDatasource(
        api: ref.watch(_imageGenApiServiceProvider),
      );
    });

/// Provider for auth local datasource (for tokens).
final _authLocalDatasourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

/// Provider for the repository.
final _imageGenRepositoryProvider = Provider<ImageGenerateRepository>((ref) {
  return ImageGenerateRepositoryImpl(
    remoteDatasource: ref.watch(_imageGenRemoteDatasourceProvider),
    authLocal: ref.watch(_authLocalDatasourceProvider),
  );
});

/// Provider for the use case.
final _generateImageUseCaseProvider = Provider<GenerateImageUseCase>((ref) {
  return GenerateImageUseCase(ref.watch(_imageGenRepositoryProvider));
});

/// Provider for the image generation controller.
final imageGenerateControllerProvider =
    ChangeNotifierProvider<ImageGenerateController>((ref) {
      return ImageGenerateController(
        generateImage: ref.watch(_generateImageUseCaseProvider),
      );
    });
