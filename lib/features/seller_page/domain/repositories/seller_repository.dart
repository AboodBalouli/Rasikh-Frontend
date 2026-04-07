import 'dart:typed_data';

import 'package:flutter_application_1/features/seller_page/domain/entities/role_change_request.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/update_store_info.dart';

abstract class SellerRepository {
  Future<RoleChangeRequest> requestSellerRole({
    required int categoryId,
    required List<Uint8List> proofs,
    String? note,
    Uint8List? certificate,
  });

  Future<SellerProfile> getMyProfile();
  Future<SellerProfile> ensureMyProfile();
  Future<SellerProfile> updateStoreInfo(UpdateStoreInfo info);
  Future<SellerProfile> updateSellerCategory(int categoryId);
  Future<List<SellerProduct>> getMyProducts();
}
