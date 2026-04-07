import '../entities/generated_image.dart';
import '../repositories/image_generate_repository.dart';

/// Use case for generating an image from a text prompt.
class GenerateImageUseCase {
  final ImageGenerateRepository _repository;

  GenerateImageUseCase(this._repository);

  /// Execute the use case with the given prompt.
  Future<GeneratedImage> call(String prompt) {
    return _repository.generateImage(prompt);
  }
}
