class Organization {
  final int id;
  final String name;
  final String description;
  final int ownerProfileId;
  final String status;
  final String government;
  final String phoneNumber;
  final String certificatePath;
  final String? profileImagePath;

  const Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerProfileId,
    required this.status,
    required this.government,
    required this.phoneNumber,
    required this.certificatePath,
    this.profileImagePath,
  });

  bool get isApproved => status.toUpperCase() == 'APPROVED';
}
