import 'package:flutter/foundation.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/usecases/generate_image_usecase.dart';

/// Message type in the image generation chat.
enum ImageMessageType { userPrompt, generatedImage }

/// A message in the image generation conversation.
class ImageMessage {
  final String id;
  final ImageMessageType type;
  final String? prompt;
  final GeneratedImage? image;
  final DateTime createdAt;

  const ImageMessage({
    required this.id,
    required this.type,
    this.prompt,
    this.image,
    required this.createdAt,
  });

  factory ImageMessage.userPrompt(String prompt) {
    return ImageMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ImageMessageType.userPrompt,
      prompt: prompt,
      createdAt: DateTime.now(),
    );
  }

  factory ImageMessage.generatedImage(GeneratedImage image) {
    return ImageMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ImageMessageType.generatedImage,
      image: image,
      createdAt: DateTime.now(),
    );
  }
}

/// Controller for image generation chat.
class ImageGenerateController extends ChangeNotifier {
  final GenerateImageUseCase _generateImage;

  ImageGenerateController({required GenerateImageUseCase generateImage})
    : _generateImage = generateImage;

  List<ImageMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ImageMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Send a prompt to generate an image.
  Future<void> sendPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return;

    // Add user message
    final userMessage = ImageMessage.userPrompt(prompt.trim());
    _messages = [..._messages, userMessage];
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Generate image
      final generatedImage = await _generateImage(prompt.trim());

      // Add AI response (image)
      final imageMessage = ImageMessage.generatedImage(generatedImage);
      _messages = [..._messages, imageMessage];
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear all messages.
  void clearMessages() {
    _messages = [];
    _error = null;
    notifyListeners();
  }

  /// Clear error.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
