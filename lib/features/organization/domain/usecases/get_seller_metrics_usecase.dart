import 'package:flutter_application_1/features/organization/domain/entities/seller_metrics.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case for getting seller metrics/dashboard data
class GetSellerMetricsUseCase {
  final SellerProductRepository repository;

  GetSellerMetricsUseCase(this.repository);

  Future<SellerMetrics> call() {
    return repository.getSellerMetrics();
  }
}
