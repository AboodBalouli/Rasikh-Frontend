import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class GetOrganizationByIdUseCase {
  final OrganizationRepository repository;

  GetOrganizationByIdUseCase(this.repository);

  Future<OrganizationDetails> call(int orgId) {
    return repository.getOrganizationDetailsById(orgId);
  }
}
