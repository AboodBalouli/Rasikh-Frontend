import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/custom_orders/data/models/custom_order_response.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order_status.dart';

/// Mapper for converting between CustomOrderResponse and CustomOrder entity.
class CustomOrderMapper {
  /// Convert response DTO to domain entity.
  static CustomOrder fromResponse(CustomOrderResponse response) {
    return CustomOrder(
      id: response.id.toString(),
      customerId: response.customerId?.toString() ?? '',
      customerFirstName: response.customerFirstName ?? '',
      customerLastName: response.customerLastName ?? '',
      sellerProfileId: response.sellerProfileId.toString(),
      sellerStoreName: response.sellerStoreName,
      title: response.title,
      description: response.description,
      location: response.location ?? '',
      phoneNumber: response.phoneNumber ?? '',
      whatsappUrl: response.whatsappUrl ?? '',
      status: CustomOrderStatus.fromString(response.status),
      imageUrls: response.images
          .map((img) => _toAbsoluteUrl(img.path))
          .toList(),
      quotedPrice: response.quotedPrice,
      estimatedDays: response.estimatedDays,
      sellerNote: response.sellerNote,
      createdAt: _parseDate(response.createdAt),
      updatedAt: response.updatedAt != null
          ? _parseDate(response.updatedAt!)
          : null,
    );
  }

  /// Convert list of responses to list of entities.
  static List<CustomOrder> fromResponseList(
    List<CustomOrderResponse> responses,
  ) {
    return responses.map(fromResponse).toList();
  }

  /// Parse date string from API.
  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Convert relative path to absolute URL.
  static String _toAbsoluteUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('/')) {
      return '${AppConfig.apiBaseUrl}$path';
    }
    return '${AppConfig.apiBaseUrl}/$path';
  }
}
