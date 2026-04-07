class RoleChangeRequest {
  final int id;
  final int userId;
  final String userEmail;
  final String requestedRole;
  final String status;
  final String? adminNote;
  final int requestedCategoryId;
  final String requestedCategoryName;

  RoleChangeRequest({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.requestedRole,
    required this.status,
    this.adminNote,
    required this.requestedCategoryId,
    required this.requestedCategoryName,
  });
}
