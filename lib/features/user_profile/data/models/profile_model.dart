import 'store_info_model.dart';
import 'seller_category_model.dart';

class ProfileModel {
  final int id;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? walletId;
  final double? walletBalance;
  final String? btcAddress;
  final String? profilePicturePath;
  final SellerCategoryModel? sellerCategory;
  final StoreInfoModel? store;

  ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    int readInt(String camel, String snake) {
      final v = json[camel] ?? json[snake];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.parse(v.toString());
    }

    String readString(String camel, String snake) {
      final v = json[camel] ?? json[snake];
      return (v ?? '').toString();
    }

    String? readNullableString(String camel, String snake) {
      final v = json.containsKey(camel) ? json[camel] : json[snake];
      return v == null ? null : v.toString();
    }

    double? readNullableDouble(String camel, String snake) {
      final v = json.containsKey(camel) ? json[camel] : json[snake];
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return ProfileModel(
      id: readInt('id', 'id'),
      userId: readInt('userId', 'user_id'),
      email: readString('email', 'email'),
      firstName: readString('firstName', 'first_name'),
      lastName: readString('lastName', 'last_name'),
      walletId: readNullableString('walletId', 'wallet_id'),
      walletBalance: readNullableDouble('walletBalance', 'wallet_balance'),
      btcAddress: readNullableString('btcAddress', 'btc_address'),
      profilePicturePath: readNullableString(
        'profilePicturePath',
        'profile_picture_path',
      ),
      sellerCategory: json['sellerCategory'] is Map<String, dynamic>
          ? SellerCategoryModel.fromJson(
              (json['sellerCategory'] as Map).cast<String, dynamic>(),
            )
          : null,
      store: json['store'] != null
          ? StoreInfoModel.fromJson(json['store'] as Map<String, dynamic>)
          : null,
    );
  }
}
