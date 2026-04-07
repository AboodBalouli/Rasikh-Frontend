import 'package:flutter/material.dart';

import '../../domain/entities/store_info.dart';
import 'package:flutter_application_1/core/network/api_endpoints.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/markets/data/models/store_response_model.dart';

class StoreInfoController extends ChangeNotifier {
  final ApiService _apiService;

  StoreInfoController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  StoreInfo? _info;
  bool _isLoading = false;
  String? _error;

  StoreInfo? get info => _info;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(String storeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sellerProfileId = int.tryParse(storeId);
      if (sellerProfileId == null) {
        _error = 'معرّف المتجر غير صالح';
        return;
      }

      // Public stores listing (SELLER profiles)
      final raw = await _apiService.get(ApiEndpoints.profileStores);
      if (raw is! Map<String, dynamic>) {
        _error = 'تعذر تحميل معلومات المتجر';
        return;
      }

      final parsed = ApiResponse<List<StoreResponseModel>>.fromJson(raw, (
        json,
      ) {
        if (json is! List) return <StoreResponseModel>[];
        return json
            .whereType<Map>()
            .map((e) => StoreResponseModel.fromJson(e.cast<String, dynamic>()))
            .toList();
      });

      if (parsed.success != true) {
        _error = parsed.error?.message ?? 'تعذر تحميل معلومات المتجر';
        return;
      }

      final stores = parsed.data ?? const <StoreResponseModel>[];
      final storeResponse = stores.cast<StoreResponseModel?>().firstWhere(
        (s) => s?.profileId == sellerProfileId,
        orElse: () => null,
      );

      if (storeResponse == null) {
        _error = 'المتجر غير موجود';
        return;
      }

      final store = storeResponse.store;
      _info = StoreInfo(
        storeName: (store?.storeName?.trim().isNotEmpty ?? false)
            ? store!.storeName!.trim()
            : storeResponse.sellerName,
        description: store?.storeDescription ?? '',
        sellerDescription: storeResponse.sellerName,
        address: store?.address ?? '',
        whatsappPhone: store?.phone ?? '',
        averageRating: store?.averageRating,
        ratingCount: store?.ratingCount,
        latitude: null,
        longitude: null,
        profilePictureUrl: storeResponse.profilePictureUrl,
        sellerProfileId: storeId,
      );
    } catch (e) {
      _error = 'تعذر تحميل معلومات المتجر';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
