import '../entities/generated_image.dart';

/// Repository contract for image generation operations.
abstract class ImageGenerateRepository {
  /// Generate an image from a text prompt.
  Future<GeneratedImage> generateImage(String prompt);
}
