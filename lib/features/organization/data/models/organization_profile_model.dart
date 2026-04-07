import 'dart:convert';

import 'package:flutter_application_1/features/organization/domain/entities/organization_profile.dart';

class OrganizationProfileModel extends OrganizationProfile {
  const OrganizationProfileModel({
    required super.name,
    required super.description,
    required super.email,
    required super.phone,
    required super.address,
    required super.website,
    super.logoPath,
    super.socialLinks,
  });

  factory OrganizationProfileModel.fromEntity(OrganizationProfile entity) {
    return OrganizationProfileModel(
      name: entity.name,
      description: entity.description,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      website: entity.website,
      logoPath: entity.logoPath,
      socialLinks: entity.socialLinks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'website': website,
      'logoPath': logoPath,
      'socialLinks': socialLinks,
    };
  }

  factory OrganizationProfileModel.fromMap(Map<String, dynamic> map) {
    return OrganizationProfileModel(
      name: (map['name'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      website: (map['website'] ?? '') as String,
      logoPath: map['logoPath'] as String?,
      socialLinks: (map['socialLinks'] is List)
          ? List<String>.from(map['socialLinks'])
          : const <String>[],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory OrganizationProfileModel.fromJson(String source) =>
      OrganizationProfileModel.fromMap(jsonDecode(source));
}
