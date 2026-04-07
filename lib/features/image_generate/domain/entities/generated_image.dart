import 'dart:typed_data';

/// Entity representing a generated image from the AI.
class GeneratedImage {
  final String originalPrompt;
  final String enhancedPrompt;
  final Uint8List imageBytes;
  final String contentType;
  final DateTime createdAt;

  const GeneratedImage({
    required this.originalPrompt,
    required this.enhancedPrompt,
    required this.imageBytes,
    required this.contentType,
    required this.createdAt,
  });
}
