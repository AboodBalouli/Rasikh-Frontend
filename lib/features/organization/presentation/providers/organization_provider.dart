import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/app/dependency_injection/organization_dependency_injection.dart';
import 'package:flutter_application_1/app/dependency_injection/products_dependency_injection.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/check_seller_has_org_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/create_organization_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/delete_org_gallery_image_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_all_organizations_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_organization_by_id_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_org_certificate_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_org_profile_image_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_org_proof_images_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/request_delete_my_org_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/upload_org_gallery_images_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/update_org_contact_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:flutter_riverpod/legacy.dart';

final organizationSearchQueryProvider = StateProvider<String>((ref) => '');

final organizationCategoryProvider = StateProvider<String>((ref) => 'All');

final checkSellerHasOrgUseCaseProvider = Provider<CheckSellerHasOrgUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return CheckSellerHasOrgUseCase(repo);
});

final currentSellerHasOrgProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  try {
    final usecase = ref.watch(checkSellerHasOrgUseCaseProvider);
    return await usecase();
  } catch (_) {
    return false;
  }
});

final getAllOrganizationsUseCaseProvider = Provider<GetAllOrganizationsUseCase>(
  (ref) {
    final repo = ref.watch(organizationRepositoryProvider);
    return GetAllOrganizationsUseCase(repo);
  },
);

final getOrganizationByIdUseCaseProvider = Provider<GetOrganizationByIdUseCase>(
  (ref) {
    final repo = ref.watch(organizationRepositoryProvider);
    return GetOrganizationByIdUseCase(repo);
  },
);

final createOrganizationUseCaseProvider = Provider<CreateOrganizationUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return CreateOrganizationUseCase(repo);
});

final requestDeleteMyOrgUseCaseProvider =
    Provider<RequestDeleteMyOrganizationUseCase>((ref) {
      final repo = ref.watch(organizationRepositoryProvider);
      return RequestDeleteMyOrganizationUseCase(repo);
    });

final getOrgProfileImageUseCaseProvider = Provider<GetOrgProfileImageUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return GetOrgProfileImageUseCase(repo);
});

final getOrgCertificateUseCaseProvider = Provider<GetOrgCertificateUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return GetOrgCertificateUseCase(repo);
});

final getOrgProofImagesUseCaseProvider = Provider<GetOrgProofImagesUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return GetOrgProofImagesUseCase(repo);
});

final uploadOrgGalleryImagesUseCaseProvider =
    Provider<UploadOrgGalleryImagesUseCase>((ref) {
      final repo = ref.watch(organizationRepositoryProvider);
      return UploadOrgGalleryImagesUseCase(repo);
    });

final deleteOrgGalleryImageUseCaseProvider =
    Provider<DeleteOrgGalleryImageUseCase>((ref) {
      final repo = ref.watch(organizationRepositoryProvider);
      return DeleteOrgGalleryImageUseCase(repo);
    });

final updateOrgContactUseCaseProvider = Provider<UpdateOrgContactUseCase>((
  ref,
) {
  final repo = ref.watch(organizationRepositoryProvider);
  return UpdateOrgContactUseCase(repo);
});

final uploadProfilePictureUseCaseProvider =
    Provider<UploadProfilePictureUseCase>((ref) {
      final repo = ref.watch(organizationRepositoryProvider);
      return UploadProfilePictureUseCase(repo);
    });

final organizationsProvider = FutureProvider<List<Organization>>((ref) async {
  final usecase = ref.watch(getAllOrganizationsUseCaseProvider);
  return usecase();
});

final organizationProductsBySellerIdProvider =
    FutureProvider.family<List<Product>, String>((ref, sellerId) {
      final getProducts = ref.watch(getProductsBySellerIdProvider);
      return getProducts(sellerId);
    });

final organizationDetailsByIdProvider =
    FutureProvider.family<OrganizationDetails, int>((ref, orgId) {
      final usecase = ref.watch(getOrganizationByIdUseCaseProvider);
      return usecase(orgId);
    });

final orgProfileImageProvider = FutureProvider.family<OrgImage?, int>((
  ref,
  orgId,
) {
  final usecase = ref.watch(getOrgProfileImageUseCaseProvider);
  return usecase(orgId);
});
