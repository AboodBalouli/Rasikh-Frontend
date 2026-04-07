import 'dart:typed_data';

class OrganizationApplication {
  final String name;
  final String description;
  final String government;
  final String phoneNumber;
  final Uint8List certificateBytes;
  final List<Uint8List> proofImages;
  final Uint8List? profileImageBytes;

  OrganizationApplication({
    required this.name,
    required this.description,
    required this.government,
    required this.phoneNumber,
    required this.certificateBytes,
    required this.proofImages,
    this.profileImageBytes,
  });
}
