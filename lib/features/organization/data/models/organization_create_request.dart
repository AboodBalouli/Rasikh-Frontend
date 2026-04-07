class OrganizationCreateRequest {
  final String name;
  final String description;
  final String government;
  final String phoneNumber;

  OrganizationCreateRequest({
    required this.name,
    required this.description,
    required this.government,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'government': government,
      'phoneNumber': phoneNumber,
    };
  }
}
