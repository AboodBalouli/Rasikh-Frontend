class OrganizationResponse {
  final int id;
  final String name;
  final String description;
  final int ownerProfileId;
  final String status;
  final String government;
  final String phoneNumber;
  final String certificatePath;
  final String? profileImagePath;

  OrganizationResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerProfileId,
    required this.status,
    required this.government,
    required this.phoneNumber,
    required this.certificatePath,
    required this.profileImagePath,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationResponse(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      ownerProfileId: (json['ownerProfileId'] ?? 0) as int,
      status: (json['status'] ?? '') as String,
      government: (json['government'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      certificatePath: (json['certificatePath'] ?? '') as String,
      profileImagePath: json['imagePath'] as String?,
    );
  }
}
