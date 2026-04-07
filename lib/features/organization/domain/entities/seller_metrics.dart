import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';

/// Domain entity representing seller metrics/dashboard data
class SellerMetrics {
  final int productCount;
  final int deletedCount;
  final double totalValue;
  final double averageRating;
  final int pendingOrdersCount;
  final double successOrdersTotalAmount;
  final List<SellerProduct> activeProducts;
  final List<SellerProduct> allProducts;

  const SellerMetrics({
    required this.productCount,
    required this.deletedCount,
    required this.totalValue,
    required this.averageRating,
    required this.pendingOrdersCount,
    required this.successOrdersTotalAmount,
    required this.activeProducts,
    required this.allProducts,
  });

  SellerMetrics copyWith({
    int? productCount,
    int? deletedCount,
    double? totalValue,
    double? averageRating,
    int? pendingOrdersCount,
    double? successOrdersTotalAmount,
    List<SellerProduct>? activeProducts,
    List<SellerProduct>? allProducts,
  }) {
    return SellerMetrics(
      productCount: productCount ?? this.productCount,
      deletedCount: deletedCount ?? this.deletedCount,
      totalValue: totalValue ?? this.totalValue,
      averageRating: averageRating ?? this.averageRating,
      pendingOrdersCount: pendingOrdersCount ?? this.pendingOrdersCount,
      successOrdersTotalAmount:
          successOrdersTotalAmount ?? this.successOrdersTotalAmount,
      activeProducts: activeProducts ?? this.activeProducts,
      allProducts: allProducts ?? this.allProducts,
    );
  }
}
