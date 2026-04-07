import 'package:flutter_application_1/features/organization/data/models/org_image_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/org_image.dart';

OrgImage mapOrgImageResponseToEntity(OrgImageResponse model) {
  return OrgImage(
    id: model.id,
    orgId: model.orgId,
    path: model.path,
    fileName: model.fileName,
  );
}
