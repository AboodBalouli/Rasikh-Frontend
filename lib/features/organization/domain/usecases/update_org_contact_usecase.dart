import 'package:flutter_application_1/features/organization/domain/entities/org_contact_info.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';
import 'dart:typed_data';

class UpdateOrgContactUseCase {
  final OrganizationRepository repository;

  UpdateOrgContactUseCase(this.repository);

  Future<OrgContactInfo> call({
    required String phone,
    required String description,
    Uint8List? coverImageBytes,
  }) {
    return repository.updateOrgContact(
      phone: phone,
      description: description,
      coverImageBytes: coverImageBytes,
    );
  }
}
