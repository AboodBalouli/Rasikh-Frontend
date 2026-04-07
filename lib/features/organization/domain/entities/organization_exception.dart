class OrganizationException implements Exception {
  final String message;
  const OrganizationException(this.message);

  @override
  String toString() => message;
}
