/// Request model for PUT /orgs/me/contact
class UpdateOrgContactRequest {
  final String phone;
  final String description;

  const UpdateOrgContactRequest({
    required this.phone,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'description': description,
    };
  }
}
