import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class RequestDeleteMyOrganizationUseCase {
  final OrganizationRepository repository;

  RequestDeleteMyOrganizationUseCase(this.repository);

  Future<void> call() {
    return repository.requestDeleteMyOrganization();
  }
}
