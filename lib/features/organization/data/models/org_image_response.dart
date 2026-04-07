class OrgImageResponse {
  final int? id;
  final int? orgId;
  final String path;
  final String fileName;

  OrgImageResponse({
    required this.id,
    required this.orgId,
    required this.path,
    required this.fileName,
  });

  factory OrgImageResponse.fromJson(Map<String, dynamic> json) {
    return OrgImageResponse(
      id: json['id'] as int?,
      orgId: json['orgId'] as int?,
      path: (json['path'] ?? '') as String,
      fileName: (json['fileName'] ?? '') as String,
    );
  }
}
