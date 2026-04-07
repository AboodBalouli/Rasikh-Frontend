import 'package:flutter_application_1/features/organization/data/models/org_owner_profile_response.dart';

class OrganizationDetailsResponse {
  final int id;
  final String name;
  final String description;
  final int ownerProfileId;
  final String status;
  final OrgOwnerProfileResponse? ownerProfile;

  OrganizationDetailsResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerProfileId,
    required this.status,
    required this.ownerProfile,
  });

  factory OrganizationDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationDetailsResponse(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      ownerProfileId: (json['ownerProfileId'] ?? 0) as int,
      status: (json['status'] ?? '') as String,
      ownerProfile: json['ownerProfile'] is Map<String, dynamic>
          ? OrgOwnerProfileResponse.fromJson(
              (json['ownerProfile'] as Map<String, dynamic>),
            )
          : null,
    );
  }
}
