import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

/// Use case to check if the current seller has an organization
class CheckSellerHasOrgUseCase {
  final OrganizationRepository repository;

  CheckSellerHasOrgUseCase(this.repository);

  /// Returns true if the current seller has an organization, false otherwise
  Future<bool> call() {
    return repository.hasMyOrg();
  }
}
