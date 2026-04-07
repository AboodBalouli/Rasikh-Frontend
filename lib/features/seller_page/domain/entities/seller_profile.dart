import 'package:flutter_application_1/features/seller_page/domain/entities/seller_category.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/store_info.dart';

class SellerProfile {
  final int id;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePicturePath;
  final SellerCategory? sellerCategory;
  final StoreInfo? store;

  const SellerProfile({
    required this.id,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicturePath,
    this.sellerCategory,
    this.store,
  });

  String get sellerName => '${firstName.trim()} ${lastName.trim()}'.trim();
}
