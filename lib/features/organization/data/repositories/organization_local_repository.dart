import 'dart:typed_data';

import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/organization/data/datasources/organization_remote_datasource.dart';
import 'package:flutter_application_1/features/organization/data/mappers/org_image_mapper.dart';
import 'package:flutter_application_1/features/organization/data/mappers/org_contact_mapper.dart';
import 'package:flutter_application_1/features/organization/data/mappers/organization_mapper.dart';
import 'package:flutter_application_1/features/organization/data/mappers/organization_details_mapper.dart';
import 'package:flutter_application_1/features/organization/data/models/update_org_contact_request.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_application.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_exception.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_contact_info.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDatasource remote;
  final TokenProvider tokenProvider;

  OrganizationRepositoryImpl({
    required this.remote,
    required this.tokenProvider,
  });

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const OrganizationException('Not authenticated. Please login');
    }
    return token;
  }

  @override
  Future<Organization> createOrganization(
    OrganizationApplication application,
  ) async {
    final token = await _requireToken();
    final apiResponse = await remote.createOrganization(
      application: application,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrganizationResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<void> requestDeleteMyOrganization() async {
    final token = await _requireToken();
    final apiResponse = await remote.requestDeleteMyOrganization(token: token);
    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<List<Organization>> getAllOrganizations() async {
    final apiResponse = await remote.getAllOrganizations();
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrganizationResponseToEntity).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<Organization> getOrganizationById(int orgId) async {
    final apiResponse = await remote.getOrganizationById(orgId: orgId);
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrganizationResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<OrganizationDetails> getOrganizationDetailsById(int orgId) async {
    final apiResponse = await remote.getOrganizationDetailsById(orgId: orgId);
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrganizationDetailsResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<OrgImage?> getOrgProfileImage(int orgId) async {
    final apiResponse = await remote.getOrgProfileImage(orgId: orgId);
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrgImageResponseToEntity(apiResponse.data!);
    }

    if (apiResponse.success) return null;
    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<OrgImage?> getOrgCertificate(int orgId) async {
    final apiResponse = await remote.getOrgCertificate(orgId: orgId);
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrgImageResponseToEntity(apiResponse.data!);
    }

    if (apiResponse.success) return null;
    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<List<OrgImage>> getOrgProofImages(int orgId) async {
    final apiResponse = await remote.getOrgProofImages(orgId: orgId);
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrgImageResponseToEntity).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<void> uploadOrgGalleryImages(List<Uint8List> filesBytes) async {
    final token = await _requireToken();
    final apiResponse = await remote.uploadOrgGalleryImages(
      filesBytes: filesBytes,
      token: token,
    );

    if (apiResponse.success) return;
    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<void> deleteOrgGalleryImage(int imageId) async {
    final token = await _requireToken();
    final apiResponse = await remote.deleteOrgGalleryImage(
      imageId: imageId,
      token: token,
    );

    if (apiResponse.success) return;
    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<OrgContactInfo> updateOrgContact({
    required String phone,
    required String description,
    Uint8List? coverImageBytes,
  }) async {
    final token = await _requireToken();
    final request = UpdateOrgContactRequest(
      phone: phone,
      description: description,
    );
    final apiResponse = await remote.updateOrgContact(
      request: request,
      token: token,
      coverImageBytes: coverImageBytes,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrgContactResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrganizationException(message);
  }

  @override
  Future<String> uploadProfilePictureByUserId({
    required int userId,
    required Uint8List fileBytes,
  }) async {
    final token = await _requireToken();
    final apiResponse = await remote.uploadProfilePictureByUserId(
      userId: userId,
      fileBytes: fileBytes,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }

    final message =
        apiResponse.error?.message ?? 'Failed to upload profile picture';
    throw OrganizationException(message);
  }

  @override
  Future<bool> hasMyOrg() async {
    final token = await _requireToken();
    final apiResponse = await remote.hasMyOrg(token: token);

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }

    // If there's an error or no data, default to false (no org)
    return false;
  }
}
