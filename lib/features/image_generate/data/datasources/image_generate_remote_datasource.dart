import 'package:flutter_application_1/core/network/api_service.dart';
import '../models/image_generate_request.dart';
import '../models/image_generate_response.dart';

/// Remote datasource for image generation API.
class ImageGenerateRemoteDatasource {
  final ApiService _api;
  final String _generatePath;

  ImageGenerateRemoteDatasource({
    required ApiService api,
    String generatePath = '/api/ai/img-generator/generate',
  }) : _api = api,
       _generatePath = generatePath;

  /// Send a prompt to generate an image.
  Future<ImageGenerateResponse> generateImage({
    required ImageGenerateRequest request,
    String? token,
  }) async {
    final json = await _api.post(_generatePath, request.toJson(), token: token);
    return ImageGenerateResponse.fromJson(json);
  }
}
