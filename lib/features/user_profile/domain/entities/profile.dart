// lib/src/features/profile/domain/entities/profile.dart
import 'seller_category.dart';
import 'store_info.dart';

class Profile {
  final int id;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? walletId;
  final double? walletBalance;
  final String? btcAddress;
  final String? profilePicturePath;
  final SellerCategory? sellerCategory;
  final StoreInfo? store;

  Profile({
    required this.id,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.walletId,
    this.walletBalance,
    this.btcAddress,
    this.profilePicturePath,
    this.sellerCategory,
    this.store,
  });
}
