import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_application.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class CreateOrganizationUseCase {
  final OrganizationRepository repository;

  CreateOrganizationUseCase(this.repository);

  Future<Organization> call(OrganizationApplication application) {
    return repository.createOrganization(application);
  }
}
