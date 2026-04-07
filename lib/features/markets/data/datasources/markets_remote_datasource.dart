import 'package:flutter_application_1/core/network/api_endpoints.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';

import '../models/store_response_model.dart';

abstract class MarketsRemoteDatasource {
  Future<List<StoreResponseModel>> fetchStores();
}

class MarketsRemoteDatasourceImpl implements MarketsRemoteDatasource {
  final ApiService apiService;

  MarketsRemoteDatasourceImpl(this.apiService);

  @override
  Future<List<StoreResponseModel>> fetchStores() async {
    final raw = await apiService.get(ApiEndpoints.profileStores);
    if (raw is! Map<String, dynamic>) {
      throw Exception('Unexpected response');
    }

    final parsed = ApiResponse<List<StoreResponseModel>>.fromJson(raw, (json) {
      if (json is! List) return <StoreResponseModel>[];
      return json
          .whereType<Map>()
          .map((e) => StoreResponseModel.fromJson(e.cast<String, dynamic>()))
          .toList();
    });

    if (parsed.success != true) {
      throw Exception(parsed.error?.message ?? 'Failed to load stores');
    }

    return parsed.data ?? <StoreResponseModel>[];
  }
}
