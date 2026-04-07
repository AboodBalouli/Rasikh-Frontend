class PublicOrderImageResponse {
  final int id;
  final String path;
  final String fileName;

  const PublicOrderImageResponse({
    required this.id,
    required this.path,
    required this.fileName,
  });

  factory PublicOrderImageResponse.fromJson(Map<String, dynamic> json) {
    return PublicOrderImageResponse(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String,
      fileName: json['fileName'] as String,
    );
  }
}
