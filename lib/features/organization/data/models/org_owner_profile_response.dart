import 'package:flutter_application_1/features/organization/data/models/org_store_info_response.dart';

class OrgOwnerProfileResponse {
  final int? profileId;
  final int? userId;
  final String? sellerName;
  final String? profilePictureUrl;
  final OrgStoreInfoResponse? store;

  const OrgOwnerProfileResponse({
    this.profileId,
    this.userId,
    this.sellerName,
    this.profilePictureUrl,
    this.store,
  });

  factory OrgOwnerProfileResponse.fromJson(Map<String, dynamic> json) {
    int? readInt(String key) {
      final v = json[key];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '');
    }

    String? readString(String key) {
      final v = json[key];
      return v == null ? null : v.toString();
    }

    return OrgOwnerProfileResponse(
      profileId: readInt('profileId'),
      userId: readInt('userId'),
      sellerName: readString('sellerName'),
      profilePictureUrl: readString('profilePictureUrl'),
      store: json['store'] is Map<String, dynamic>
          ? OrgStoreInfoResponse.fromJson(
              (json['store'] as Map<String, dynamic>),
            )
          : null,
    );
  }
}
