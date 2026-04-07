import '../entities/store_info.dart';

abstract class StoreRepository {
  Future<StoreInfo> getStoreInfo(String storeId);
}
