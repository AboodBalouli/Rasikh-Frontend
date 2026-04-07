class OrgImage {
  final int? id;
  final int? orgId;
  final String path;
  final String fileName;

  const OrgImage({
    this.id,
    this.orgId,
    required this.path,
    required this.fileName,
  });
}
