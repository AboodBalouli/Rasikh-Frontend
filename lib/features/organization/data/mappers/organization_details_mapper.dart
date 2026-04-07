import 'package:flutter_application_1/features/organization/data/models/organization_details_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';

OrganizationDetails mapOrganizationDetailsResponseToEntity(
  OrganizationDetailsResponse model,
) {
  final ownerProfile = model.ownerProfile;
  final store = ownerProfile?.store;
  return OrganizationDetails(
    id: model.id,
    name: model.name,
    description: model.description,
    ownerProfileId: model.ownerProfileId,
    ownerUserId: ownerProfile?.userId,
    status: model.status,
    ownerProfileImageUrl: ownerProfile?.profilePictureUrl,
    storeCountry: store?.country,
    storeGovernment: store?.government,
    storePhone: store?.phone,
    averageRating: store?.averageRating,
    ratingCount: store?.ratingCount,
  );
}
