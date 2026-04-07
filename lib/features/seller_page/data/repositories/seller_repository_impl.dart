import 'dart:typed_data';

import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/seller_page/data/mappers/profile_mapper.dart';
import 'package:flutter_application_1/features/seller_page/data/mappers/seller_product_mapper.dart';
import 'package:flutter_application_1/features/seller_page/data/models/update_store_request.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/update_store_info.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/role_change_request.dart';
import '../datasources/seller_remote_datasource.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;
  final TokenProvider tokenProvider;

  SellerRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenProvider,
  });

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    return token;
  }

  @override
  Future<RoleChangeRequest> requestSellerRole({
    required int categoryId,
    required List<Uint8List> proofs,
    String? note,
    Uint8List? certificate,
  }) async {
    final token = await _requireToken();
    final response = await remoteDataSource.requestSellerRole(
      token: token,
      categoryId: categoryId,
      proofs: proofs,
      note: note,
      certificate: certificate,
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      // Throw appropriate exception based on response.error
      throw Exception(response.error?.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<SellerProfile> getMyProfile() async {
    final token = await _requireToken();
    final response = await remoteDataSource.getMyProfile(token: token);
    if (response.success && response.data != null) {
      return mapProfileResponseToEntity(response.data!);
    }
    throw Exception(response.error?.message ?? 'Failed to load profile');
  }

  @override
  Future<SellerProfile> ensureMyProfile() async {
    final token = await _requireToken();
    final response = await remoteDataSource.ensureMyProfile(token: token);
    if (response.success && response.data != null) {
      return mapProfileResponseToEntity(response.data!);
    }
    throw Exception(response.error?.message ?? 'Failed to ensure profile');
  }

  @override
  Future<SellerProfile> updateStoreInfo(UpdateStoreInfo info) async {
    final token = await _requireToken();
    final request = UpdateStoreRequest(
      address: info.address,
      phone: info.phone,
      workingHours: info.workingHours,
      storeName: info.storeName,
      country: info.country,
      government: info.government,
      themeColor: info.themeColor,
      firstName: info.firstName,
      lastName: info.lastName,
      tags: info.tags,
    );

    final response = await remoteDataSource.updateStoreInfo(
      request: request,
      token: token,
    );
    if (response.success && response.data != null) {
      return mapProfileResponseToEntity(response.data!);
    }
    throw Exception(response.error?.message ?? 'Failed to update store');
  }

  @override
  Future<SellerProfile> updateSellerCategory(int categoryId) async {
    final token = await _requireToken();
    final response = await remoteDataSource.updateSellerCategory(
      categoryId: categoryId,
      token: token,
    );
    if (response.success && response.data != null) {
      return mapProfileResponseToEntity(response.data!);
    }
    throw Exception(response.error?.message ?? 'Failed to update category');
  }

  @override
  Future<List<SellerProduct>> getMyProducts() async {
    final token = await _requireToken();
    final profile = await getMyProfile();
    final response = await remoteDataSource.getProductsBySellerId(
      sellerId: profile.id.toString(),
      token: token,
    );
    if (response.success && response.data != null) {
      return response.data!.map(mapSellerProductResponseToEntity).toList();
    }
    throw Exception(response.error?.message ?? 'Failed to load products');
  }
}
