/// Model representing organization info for admin editing.
class AdminOrganizationInfo {
  const AdminOrganizationInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.coverImageUrl,
    this.ownerUserId,
  });

  final String id;
  final String name;
  final String description;
  final String phone;
  final String coverImageUrl;
  final int? ownerUserId; // For profile picture upload

  AdminOrganizationInfo copyWith({
    String? id,
    String? name,
    String? description,
    String? phone,
    String? coverImageUrl,
    int? ownerUserId,
  }) {
    return AdminOrganizationInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ownerUserId: ownerUserId ?? this.ownerUserId,
    );
  }
}
