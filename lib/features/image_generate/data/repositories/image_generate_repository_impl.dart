import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/repositories/image_generate_repository.dart';
import '../datasources/image_generate_remote_datasource.dart';
import '../models/image_generate_request.dart';

/// Implementation of ImageGenerateRepository.
class ImageGenerateRepositoryImpl implements ImageGenerateRepository {
  final ImageGenerateRemoteDatasource _remoteDatasource;
  final AuthLocalDataSource _authLocal;

  ImageGenerateRepositoryImpl({
    required ImageGenerateRemoteDatasource remoteDatasource,
    required AuthLocalDataSource authLocal,
  }) : _remoteDatasource = remoteDatasource,
       _authLocal = authLocal;

  @override
  Future<GeneratedImage> generateImage(String prompt) async {
    final token = await _authLocal.getToken();

    final request = ImageGenerateRequest(prompt: prompt);
    final response = await _remoteDatasource.generateImage(
      request: request,
      token: token,
    );

    return GeneratedImage(
      originalPrompt: response.originalPrompt,
      enhancedPrompt: response.enhancedPrompt,
      imageBytes: response.imageBytes,
      contentType: response.contentType,
      createdAt: DateTime.now(),
    );
  }
}
