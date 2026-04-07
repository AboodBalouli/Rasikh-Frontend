import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class GetOrgProofImagesUseCase {
  final OrganizationRepository repository;

  GetOrgProofImagesUseCase(this.repository);

  Future<List<OrgImage>> call(int orgId) {
    return repository.getOrgProofImages(orgId);
  }
}
