/// Response model for PUT /orgs/me/contact
class UpdateOrgContactResponse {
  final int orgId;
  final int ownerProfileId;
  final String phone;
  final String description;

  const UpdateOrgContactResponse({
    required this.orgId,
    required this.ownerProfileId,
    required this.phone,
    required this.description,
  });

  factory UpdateOrgContactResponse.fromJson(Map<String, dynamic> json) {
    return UpdateOrgContactResponse(
      orgId: (json['orgId'] ?? 0) as int,
      ownerProfileId: (json['ownerProfileId'] ?? 0) as int,
      phone: (json['phone'] ?? '') as String,
      description: (json['description'] ?? '') as String,
    );
  }
}
