import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class GetAllOrganizationsUseCase {
  final OrganizationRepository repository;

  GetAllOrganizationsUseCase(this.repository);

  Future<List<Organization>> call() {
    return repository.getAllOrganizations();
  }
}
