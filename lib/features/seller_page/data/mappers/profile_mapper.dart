import 'package:flutter_application_1/features/seller_page/data/models/profile_response.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_category.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/store_info.dart';

SellerProfile mapProfileResponseToEntity(ProfileResponse response) {
  return SellerProfile(
    id: response.id,
    userId: response.userId,
    email: response.email,
    firstName: response.firstName,
    lastName: response.lastName,
    profilePicturePath: response.profilePicturePath,
    sellerCategory: response.sellerCategory == null
        ? null
        : SellerCategory(
            id: response.sellerCategory!.id,
            name: response.sellerCategory!.name,
          ),
    store: response.store == null
        ? null
        : StoreInfo(
            address: response.store!.address,
            phone: response.store!.phone,
            workingHours: response.store!.workingHours,
            totalSales: response.store!.totalSales,
            storeName: response.store!.storeName,
            storeDescription: response.store!.storeDescription,
            averageRating: response.store!.averageRating,
            ratingCount: response.store!.ratingCount,
            country: response.store!.country,
            government: response.store!.government,
            themeColor: response.store!.themeColor,
            tags: response.store!.tags,
          ),
  );
}
