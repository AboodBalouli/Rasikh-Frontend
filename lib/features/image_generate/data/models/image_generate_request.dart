/// Request model for image generation API.
class ImageGenerateRequest {
  final String prompt;

  const ImageGenerateRequest({required this.prompt});

  Map<String, dynamic> toJson() => {'prompt': prompt};
}
