import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:flutter_application_1/features/orders/data/mappers/orders_mapper.dart';
import 'package:flutter_application_1/features/orders/data/models/create_order_request_model.dart';
import 'package:flutter_application_1/features/orders/data/models/update_order_status_request_model.dart';
import 'package:flutter_application_1/features/orders/domain/entities/create_order_request.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_status.dart';
import 'package:flutter_application_1/features/orders/domain/entities/orders_exception.dart';
import 'package:flutter_application_1/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDatasource remote;
  final TokenProvider tokenProvider;

  OrdersRepositoryImpl({required this.remote, required this.tokenProvider});

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const OrdersException('Not authenticated. Please login again');
    }
    return token;
  }

  @override
  Future<Order> createOrder(CreateOrderRequest request) async {
    final apiResponse = await remote.createOrder(
      request: CreateOrderRequestModel(
        shippingAddress: request.shippingAddress,
        phoneNumber: request.phoneNumber,
        notes: request.notes,
      ),
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToDomain(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<List<Order>> fetchMyOrders() async {
    final apiResponse = await remote.getMyOrders(token: await _requireToken());

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrderResponseToDomain).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<List<Order>> fetchMyOrdersByStatus(OrderStatus status) async {
    final apiResponse = await remote.getMyOrdersByStatus(
      status: mapOrderStatusDomainToApi(status),
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapOrderResponseToDomain).toList();
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<Order> fetchOrderById(int orderId) async {
    final apiResponse = await remote.getOrderById(
      orderId: orderId,
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToDomain(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<Order> updateOrderStatus({
    required int orderId,
    required OrderStatus newStatus,
  }) async {
    final apiResponse = await remote.updateOrderStatus(
      orderId: orderId,
      request: UpdateOrderStatusRequestModel(
        newStatus: mapOrderStatusDomainToApi(newStatus),
      ),
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToDomain(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<Order> cancelOrder(int orderId) async {
    final apiResponse = await remote.cancelOrder(
      orderId: orderId,
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapOrderResponseToDomain(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    final apiResponse = await remote.deleteOrder(
      orderId: orderId,
      token: await _requireToken(),
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }

  @override
  Future<int> getMyOrdersCount() async {
    final apiResponse = await remote.getMyOrdersCount(
      token: await _requireToken(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }

    final message = apiResponse.error?.message ?? 'Unknown error occurred';
    throw OrdersException(message);
  }
}
