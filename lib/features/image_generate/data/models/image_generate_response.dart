import 'dart:convert';
import 'dart:typed_data';

/// Response model for image generation API.
class ImageGenerateResponse {
  final String originalPrompt;
  final String enhancedPrompt;
  final String base64Image;
  final String contentType;

  const ImageGenerateResponse({
    required this.originalPrompt,
    required this.enhancedPrompt,
    required this.base64Image,
    required this.contentType,
  });

  factory ImageGenerateResponse.fromJson(Map<String, dynamic> json) {
    return ImageGenerateResponse(
      originalPrompt: json['original_prompt'] as String? ?? '',
      enhancedPrompt: json['enhanced_prompt'] as String? ?? '',
      base64Image: json['base64_image'] as String? ?? '',
      contentType: json['content_type'] as String? ?? 'image/png',
    );
  }

  /// Decode the base64 image string to bytes.
  Uint8List get imageBytes {
    // Clean the string (remove any newlines)
    final cleanedBase64 = base64Image
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .trim();
    return base64Decode(cleanedBase64);
  }
}
