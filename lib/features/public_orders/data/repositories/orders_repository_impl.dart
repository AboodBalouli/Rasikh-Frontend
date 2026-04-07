import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/public_orders/data/datasources/public_orders_remote_datasource.dart';
import 'package:flutter_application_1/features/public_orders/data/mappers/public_order_request_mapper.dart';
import 'package:flutter_application_1/features/public_orders/data/models/public_order_status_update_request.dart';
import 'package:flutter_application_1/features/public_orders/data/models/public_order_update_request.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/orders_exception.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';
import 'dart:io';

import '../mappers/public_order_mapper.dart';

class OrdersRepositoryImpl implements PublicOrdersRepository {
  final PublicOrdersRemoteDatasource remote;
  final TokenProvider tokenProvider;

  OrdersRepositoryImpl({required this.remote, required this.tokenProvider});

  @override
  Future<List<PublicOrder>> fetchPublicOrders({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    final apiResponse = await remote.getPublicOrders(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrderResponseToPublicOrder).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<PublicOrder> fetchPublicOrderById(String id) async {
    final apiResponse = await remote.getPublicOrderById(
      id,
    );
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToPublicOrder(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const OrdersException('Not authenticated. Please login again');
    }
    return token;
  }

  @override
  Future<List<PublicOrder>> fetchMyPublicOrders() async {
    final token = await _requireToken();
    final apiResponse = await remote.getMyPublicOrders(token);

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrderResponseToPublicOrder).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<List<PublicOrder>> fetchPublicOrdersByStatus({
    required String status,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    final apiResponse = await remote.getPublicOrdersByStatus(
      status: status,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrderResponseToPublicOrder).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<PublicOrder> createPublicOrder(PublicOrder order) async {
    final req = mapPublicOrderToOrderRequest(order);
    final token = await _requireToken();

    final apiResponse = await remote.createPublicOrder(req, token);
    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToPublicOrder(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<PublicOrder> updatePublicOrder({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? location,
    String? phoneNumber,
    String? whatsappUrl,
  }) async {
    final token = await _requireToken();
    final update = PublicOrderUpdateRequest(
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
    );

    final apiResponse = await remote.updatePublicOrder(
      id: id,
      update: update,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToPublicOrder(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<PublicOrder> updatePublicOrderStatus({
    required String id,
    required String status,
  }) async {
    final token = await _requireToken();
    final update = PublicOrderStatusUpdateRequest(status: status);
    final apiResponse = await remote.updatePublicOrderStatus(
      id: id,
      update: update,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToPublicOrder(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<void> deletePublicOrder(String id) async {
    final token = await _requireToken();
    final apiResponse = await remote.deletePublicOrder(id: id, token: token);
    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<int> getMyOrdersCount() async {
    final token = await _requireToken();
    final apiResponse = await remote.getMyOrdersCount(token);
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<void> uploadPublicOrderImages({
    required String publicOrderId,
    required List<String> filePaths,
  }) async {
    final token = await _requireToken();
    final files = filePaths.map((p) => File(p)).toList();
    final apiResponse = await remote.uploadPublicOrderImages(
      publicOrderId: publicOrderId,
      files: files,
      token: token,
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<List<String>> fetchPublicOrderImagePaths(String publicOrderId) async {
    final apiResponse = await remote.getPublicOrderImages(publicOrderId);

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!
          .map((img) => img.path)
          .where((p) => p.trim().isNotEmpty)
          .toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }
}
