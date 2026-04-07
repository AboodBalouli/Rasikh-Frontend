import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class UploadOrgGalleryImagesUseCase {
  final OrganizationRepository repository;

  UploadOrgGalleryImagesUseCase(this.repository);

  Future<void> call(List<Uint8List> filesBytes) {
    return repository.uploadOrgGalleryImages(filesBytes);
  }
}
