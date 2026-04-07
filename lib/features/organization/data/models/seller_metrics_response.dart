import 'package:flutter_application_1/features/organization/data/models/seller_product_response.dart';

/// Response model for seller metrics
/// GET /api/product/my/metrics
class SellerMetricsResponse {
  final int productCount;
  final int deletedCount;
  final double totalValue;
  final double averageRating;
  final int pendingOrdersCount;
  final double successOrdersTotalAmount;
  final List<SellerProductResponse> activeProducts;
  final List<SellerProductResponse> allProducts;
  final Map<String, dynamic>? activeAccount;

  const SellerMetricsResponse({
    required this.productCount,
    required this.deletedCount,
    required this.totalValue,
    required this.averageRating,
    required this.pendingOrdersCount,
    required this.successOrdersTotalAmount,
    required this.activeProducts,
    required this.allProducts,
    this.activeAccount,
  });

  factory SellerMetricsResponse.fromJson(Map<String, dynamic> json) {
    return SellerMetricsResponse(
      productCount: (json['productCount'] ?? 0) as int,
      deletedCount: (json['deletedCount'] ?? 0) as int,
      totalValue: (json['totalValue'] is num)
          ? (json['totalValue'] as num).toDouble()
          : 0.0,
      averageRating: (json['averageRating'] is num)
          ? (json['averageRating'] as num).toDouble()
          : 0.0,
      pendingOrdersCount: (json['pendingOrdersCount'] ?? 0) as int,
      successOrdersTotalAmount: (json['successOrdersTotalAmount'] is num)
          ? (json['successOrdersTotalAmount'] as num).toDouble()
          : 0.0,
      activeProducts:
          (json['activeProducts'] as List<dynamic>?)
              ?.map(
                (item) => SellerProductResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      allProducts:
          (json['allProducts'] as List<dynamic>?)
              ?.map(
                (item) => SellerProductResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      activeAccount: json['activeAccount'] as Map<String, dynamic>?,
    );
  }
}
