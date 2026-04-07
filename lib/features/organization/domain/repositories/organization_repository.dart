import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_application.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_contact_info.dart';

abstract class OrganizationRepository {
  Future<Organization> createOrganization(OrganizationApplication application);
  Future<void> requestDeleteMyOrganization();
  Future<List<Organization>> getAllOrganizations();
  Future<Organization> getOrganizationById(int orgId);
  Future<OrganizationDetails> getOrganizationDetailsById(int orgId);
  Future<OrgImage?> getOrgProfileImage(int orgId);
  Future<OrgImage?> getOrgCertificate(int orgId);
  Future<List<OrgImage>> getOrgProofImages(int orgId);
  Future<void> uploadOrgGalleryImages(List<Uint8List> filesBytes);
  Future<void> deleteOrgGalleryImage(int imageId);
  Future<OrgContactInfo> updateOrgContact({
    required String phone,
    required String description,
    Uint8List? coverImageBytes,
  });

  /// Upload profile picture by userId (endpoint 6 from images.md)
  Future<String> uploadProfilePictureByUserId({
    required int userId,
    required Uint8List fileBytes,
  });

  /// Check if the current seller has an organization
  Future<bool> hasMyOrg();
}
