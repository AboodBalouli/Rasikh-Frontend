import 'package:flutter_application_1/features/organization/data/mappers/seller_product_mapper.dart';
import 'package:flutter_application_1/features/organization/data/models/seller_metrics_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_metrics.dart';

/// Maps SellerMetricsResponse to SellerMetrics entity
SellerMetrics mapSellerMetricsResponseToEntity(SellerMetricsResponse response) {
  return SellerMetrics(
    productCount: response.productCount,
    deletedCount: response.deletedCount,
    totalValue: response.totalValue,
    averageRating: response.averageRating,
    pendingOrdersCount: response.pendingOrdersCount,
    successOrdersTotalAmount: response.successOrdersTotalAmount,
    activeProducts: mapSellerProductResponseListToEntities(
      response.activeProducts,
    ),
    allProducts: mapSellerProductResponseListToEntities(response.allProducts),
  );
}
