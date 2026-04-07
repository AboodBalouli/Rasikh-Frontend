/// Domain entity for organization contact info
class OrgContactInfo {
  final int orgId;
  final int ownerProfileId;
  final String phone;
  final String description;

  const OrgContactInfo({
    required this.orgId,
    required this.ownerProfileId,
    required this.phone,
    required this.description,
  });
}
