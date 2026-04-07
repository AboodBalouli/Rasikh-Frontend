import '../../domain/entities/role_change_request.dart';

class RoleChangeRequestResponse extends RoleChangeRequest {
  RoleChangeRequestResponse({
    required super.id,
    required super.userId,
    required super.userEmail,
    required super.requestedRole,
    required super.status,
    super.adminNote,
    required super.requestedCategoryId,
    required super.requestedCategoryName,
  });

  factory RoleChangeRequestResponse.fromJson(Map<String, dynamic> json) {
    return RoleChangeRequestResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      userEmail: json['userEmail'] as String,
      requestedRole: json['requestedRole'] as String,
      status: json['status'] as String,
      adminNote: json['adminNote'] as String?,
      requestedCategoryId: json['requestedCategoryId'] as int,
      requestedCategoryName: json['requestedCategoryName'] as String,
    );
  }
}
