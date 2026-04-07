import 'package:flutter_application_1/features/seller_page/data/models/seller_category_response.dart';
import 'package:flutter_application_1/features/seller_page/data/models/store_info_response.dart';

class ProfileResponse {
  final int id;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePicturePath;
  final SellerCategoryResponse? sellerCategory;
  final StoreInfoResponse? store;

  ProfileResponse({
    required this.id,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicturePath,
    this.sellerCategory,
    this.store,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    int readInt(String camel, String snake) {
      final v = json[camel] ?? json[snake];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    String readString(String camel, String snake) {
      final v = json[camel] ?? json[snake];
      return (v ?? '').toString();
    }

    String? readNullableString(String camel, String snake) {
      final v = json.containsKey(camel) ? json[camel] : json[snake];
      return v == null ? null : v.toString();
    }

    return ProfileResponse(
      id: readInt('id', 'id'),
      userId: readInt('userId', 'user_id'),
      email: readString('email', 'email'),
      firstName: readString('firstName', 'first_name'),
      lastName: readString('lastName', 'last_name'),
      profilePicturePath: readNullableString(
        'profilePicturePath',
        'profile_picture_path',
      ),
      sellerCategory: json['sellerCategory'] is Map<String, dynamic>
          ? SellerCategoryResponse.fromJson(
              (json['sellerCategory'] as Map).cast<String, dynamic>(),
            )
          : null,
      store: json['store'] is Map<String, dynamic>
          ? StoreInfoResponse.fromJson(
              (json['store'] as Map).cast<String, dynamic>(),
            )
          : null,
    );
  }
}
