import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/store_info.dart';
import '../../domain/repositories/store_repository.dart';
import '../models/store_info_model.dart';

class StoreRepositoryImpl implements StoreRepository {
  final http.Client _client;
  final String _baseUrl;

  StoreRepositoryImpl({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? 'https://api.example.com';

  @override
  Future<StoreInfo> getStoreInfo(String storeId) async {
    try {
      // Placeholder endpoint; backend can replace with real one.
      final uri = Uri.parse('$_baseUrl/stores/$storeId');
      final res = await _client.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return StoreInfoModel.fromJson(data);
      }
    } catch (_) {
      // Swallow network/parse errors and use fallback.
    }

    // Fallback dummy data to keep UI working until backend is wired.
    return const StoreInfo(
      storeName: 'المتجر',
      description: 'وصف المتجر',
      sellerDescription: 'وصف البائع',
      address: 'عمان، الأردن',
      whatsappPhone: '+962791234567',
      latitude: 31.9539,
      longitude: 35.9106,
    );
  }
}
