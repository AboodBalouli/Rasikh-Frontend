import 'package:flutter_application_1/features/organization/data/models/update_org_contact_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_contact_info.dart';

OrgContactInfo mapOrgContactResponseToEntity(UpdateOrgContactResponse model) {
  return OrgContactInfo(
    orgId: model.orgId,
    ownerProfileId: model.ownerProfileId,
    phone: model.phone,
    description: model.description,
  );
}
