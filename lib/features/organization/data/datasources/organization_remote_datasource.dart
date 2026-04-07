import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/organization/data/models/org_image_response.dart';
import 'package:flutter_application_1/features/organization/data/models/organization_details_response.dart';
import 'package:flutter_application_1/features/organization/data/models/organization_create_request.dart';
import 'package:flutter_application_1/features/organization/data/models/organization_response.dart';
import 'package:flutter_application_1/features/organization/data/models/update_org_contact_request.dart';
import 'package:flutter_application_1/features/organization/data/models/update_org_contact_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_application.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class OrganizationRemoteDatasource {
  final http.Client client;

  OrganizationRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  static List<dynamic> _extractList(Object? json) {
    if (json is List<dynamic>) return json;

    if (json is Map) {
      final map = json.cast<String, dynamic>();
      for (final key in const ['content', 'items', 'results', 'data']) {
        final value = map[key];
        if (value is List<dynamic>) return value;
      }
    }

    throw const FormatException(
      'Expected a List or a paginated Map containing a List under content/items/results/data',
    );
  }

  Future<ApiResponse<OrganizationResponse>> createOrganization({
    required OrganizationApplication application,
    required String token,
  }) async {
    final url = _apiUri('/orgs');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    final data = OrganizationCreateRequest(
      name: application.name,
      description: application.description,
      government: application.government,
      phoneNumber: application.phoneNumber,
    );

    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(data.toJson()),
        contentType: MediaType('application', 'json'),
      ),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'certificate',
        application.certificateBytes,
        filename: 'certificate.jpg',
      ),
    );

    for (var i = 0; i < application.proofImages.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'proof',
          application.proofImages[i],
          filename: 'proof_${i + 1}.jpg',
        ),
      );
    }

    final profile = application.profileImageBytes;
    if (profile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'profileImage',
          profile,
          filename: 'profile.jpg',
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<OrganizationResponse>.fromJson(decoded, (json) {
      return OrganizationResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  Future<ApiResponse<String>> requestDeleteMyOrganization({
    required String token,
  }) async {
    final url = _apiUri('/orgs/request-delete');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }

  Future<ApiResponse<List<OrganizationResponse>>> getAllOrganizations() async {
    final url = _apiUri('/orgs/all-orgs');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<OrganizationResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                OrganizationResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  Future<ApiResponse<OrganizationResponse>> getOrganizationById({
    required int orgId,
  }) async {
    final url = _apiUri('/orgs/$orgId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<OrganizationResponse>.fromJson(decoded, (json) {
      return OrganizationResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  Future<ApiResponse<OrganizationDetailsResponse>> getOrganizationDetailsById({
    required int orgId,
  }) async {
    final url = _apiUri('/orgs/$orgId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<OrganizationDetailsResponse>.fromJson(decoded, (json) {
      return OrganizationDetailsResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  Future<ApiResponse<OrgImageResponse>> getOrgProfileImage({
    required int orgId,
  }) async {
    final url = _apiUri('/images/orgs/$orgId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<OrgImageResponse>.fromJson(decoded, (json) {
      final list = _extractList(json);
      if (list.isEmpty) {
        return OrgImageResponse(id: null, orgId: orgId, path: '', fileName: '');
      }
      return OrgImageResponse.fromJson(list.first as Map<String, dynamic>);
    });
  }

  Future<ApiResponse<OrgImageResponse>> getOrgCertificate({
    required int orgId,
  }) async {
    final url = _apiUri('/images/certificate/org/$orgId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<OrgImageResponse>.fromJson(decoded, (json) {
      return OrgImageResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  Future<ApiResponse<List<OrgImageResponse>>> getOrgProofImages({
    required int orgId,
  }) async {
    final url = _apiUri('/images/proof/org/$orgId');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<OrgImageResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) => OrgImageResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  Future<ApiResponse<String>> uploadOrgGalleryImages({
    required List<Uint8List> filesBytes,
    required String token,
  }) async {
    final url = _apiUri('/images/orgs');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    for (var i = 0; i < filesBytes.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          filesBytes[i],
          filename: 'org_image_${i + 1}.jpg',
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }

  Future<ApiResponse<String>> deleteOrgGalleryImage({
    required int imageId,
    required String token,
  }) async {
    final url = _apiUri('/images/orgs/image/$imageId');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }

  /// PUT /orgs/me/contact - Update org contact details
  Future<ApiResponse<UpdateOrgContactResponse>> updateOrgContact({
    required UpdateOrgContactRequest request,
    required String token,
    Uint8List? coverImageBytes,
  }) async {
    final url = _apiUri('/orgs/me/contact');
    if (coverImageBytes == null) {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected JSON object response');
      }

      return ApiResponse<UpdateOrgContactResponse>.fromJson(decoded, (json) {
        return UpdateOrgContactResponse.fromJson(json as Map<String, dynamic>);
      });
    }

    // Multipart with cover image bytes
    final multipart = http.MultipartRequest('PUT', url);
    multipart.headers['Authorization'] = 'Bearer $token';
    multipart.fields['phone'] = request.phone;
    multipart.fields['description'] = request.description;
    multipart.files.add(
      http.MultipartFile.fromBytes(
        'coverImage',
        coverImageBytes,
        filename: 'cover.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamed = await multipart.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<UpdateOrgContactResponse>.fromJson(decoded, (json) {
      return UpdateOrgContactResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// GET /orgs/me/has-org - Check if current seller has an organization
  Future<ApiResponse<bool>> hasMyOrg({required String token}) async {
    final url = _apiUri('/orgs/me/has-org');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<bool>.fromJson(decoded, (json) {
      return json == true;
    });
  }

  /// POST /images/profile/user/{userId} - Upload profile picture by userId
  /// This is used to upload/update the organization owner's profile picture
  Future<ApiResponse<String>> uploadProfilePictureByUserId({
    required int userId,
    required Uint8List fileBytes,
    required String token,
  }) async {
    final url = _apiUri('/images/profile/user/$userId');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: 'profile_picture.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }
}
