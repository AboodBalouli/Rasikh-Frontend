import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class GetOrgProfileImageUseCase {
  final OrganizationRepository repository;

  GetOrgProfileImageUseCase(this.repository);

  Future<OrgImage?> call(int orgId) {
    return repository.getOrgProfileImage(orgId);
  }
}
