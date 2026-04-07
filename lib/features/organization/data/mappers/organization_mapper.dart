import 'package:flutter_application_1/features/organization/data/models/organization_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';

Organization mapOrganizationResponseToEntity(OrganizationResponse model) {
  return Organization(
    id: model.id,
    name: model.name,
    description: model.description,
    ownerProfileId: model.ownerProfileId,
    status: model.status,
    government: model.government,
    phoneNumber: model.phoneNumber,
    certificatePath: model.certificatePath,
    profileImagePath: model.profileImagePath,
  );
}
