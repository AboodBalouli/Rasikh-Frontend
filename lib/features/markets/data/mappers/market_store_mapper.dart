import '../../domain/entities/market_store.dart';
import '../models/store_response_model.dart';

class MarketStoreMapper {
  const MarketStoreMapper();

  MarketStore toEntity(StoreResponseModel model) {
    // Use storeName if available, otherwise fall back to sellerName
    final displayName = (model.store?.storeName?.isNotEmpty ?? false)
        ? model.store!.storeName!
        : model.sellerName.isNotEmpty
        ? model.sellerName
        : 'متجر';

    return MarketStore(
      profileId: model.profileId,
      userId: model.userId,
      sellerName: displayName,
      storeName: model.store?.storeName,
      storeDescription: model.store?.storeDescription,
      profilePictureUrl: model.profilePictureUrl,
      categoryName: model.sellerCategory?.name,
      categoryId: model.sellerCategory?.id,
      address: model.store?.address,
      phone: model.store?.phone,
      workingHours: model.store?.workingHours,
      totalSales: model.store?.totalSales,
      averageRating: model.store?.averageRating,
      ratingCount: model.store?.ratingCount,
      // country and government come from inside store object per API response
      country: model.store?.country ?? model.country,
      government: model.store?.government ?? model.government,
      themeColor: model.store?.themeColor,
      tags: model.store?.tags ?? [],
    );
  }
}
