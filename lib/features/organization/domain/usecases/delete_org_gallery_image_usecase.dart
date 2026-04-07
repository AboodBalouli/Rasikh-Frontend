import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class DeleteOrgGalleryImageUseCase {
  final OrganizationRepository repository;

  DeleteOrgGalleryImageUseCase(this.repository);

  Future<void> call(int imageId) {
    return repository.deleteOrgGalleryImage(imageId);
  }
}
