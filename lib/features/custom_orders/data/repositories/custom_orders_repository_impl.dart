import 'dart:io';

import 'package:flutter_application_1/features/custom_orders/data/datasources/custom_orders_remote_datasource.dart';
import 'package:flutter_application_1/features/custom_orders/data/mappers/custom_order_mapper.dart';
import 'package:flutter_application_1/features/custom_orders/data/models/custom_order_request.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/repositories/custom_orders_repository.dart';

/// Concrete implementation of CustomOrdersRepository.
class CustomOrdersRepositoryImpl implements CustomOrdersRepository {
  final CustomOrdersRemoteDatasource _datasource;

  CustomOrdersRepositoryImpl(this._datasource);

  @override
  Future<CustomOrder> createCustomOrder({
    required String sellerProfileId,
    required String title,
    required String description,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
    List<String>? imagePaths,
  }) async {
    final request = CustomOrderRequest(
      sellerProfileId: int.parse(sellerProfileId),
      title: title,
      description: description,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
    );

    final response = imagePaths != null && imagePaths.isNotEmpty
        ? await _datasource.createCustomOrderWithImages(
            request: request,
            files: imagePaths.map((p) => File(p)).toList(),
          )
        : await _datasource.createCustomOrder(request);

    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to create custom order',
      );
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<List<CustomOrder>> getMyCustomOrders() async {
    final response = await _datasource.getMyCustomOrders();

    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch custom orders',
      );
    }

    return CustomOrderMapper.fromResponseList(response.data!);
  }

  @override
  Future<CustomOrder> getCustomOrderById(String id) async {
    final response = await _datasource.getCustomOrderById(id);

    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch custom order',
      );
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<CustomOrder> updateCustomOrder({
    required String id,
    String? title,
    String? description,
    String? location,
  }) async {
    final request = CustomOrderUpdateRequest(
      title: title,
      description: description,
      location: location,
    );

    final response = await _datasource.updateCustomOrder(
      id: id,
      request: request,
    );

    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to update custom order',
      );
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<CustomOrder> cancelCustomOrder(String id) async {
    final response = await _datasource.cancelCustomOrder(id);

    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to cancel custom order',
      );
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<CustomOrder> acceptQuote(String id) async {
    final response = await _datasource.acceptQuote(id);

    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to accept quote');
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<List<CustomOrder>> getSellerInbox() async {
    final response = await _datasource.getSellerInbox();

    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to fetch inbox');
    }

    return CustomOrderMapper.fromResponseList(response.data!);
  }

  @override
  Future<CustomOrder> quoteCustomOrder({
    required String id,
    required double quotedPrice,
    required int estimatedDays,
    String? sellerNote,
  }) async {
    final request = CustomOrderQuoteRequest(
      quotedPrice: quotedPrice,
      estimatedDays: estimatedDays,
      sellerNote: sellerNote,
    );

    final response = await _datasource.quoteCustomOrder(
      id: id,
      request: request,
    );

    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to quote order');
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }

  @override
  Future<CustomOrder> rejectCustomOrder(String id) async {
    final response = await _datasource.rejectCustomOrder(id);

    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to reject order');
    }

    return CustomOrderMapper.fromResponse(response.data!);
  }
}
