import 'package:flutter_application_1/features/seller_page/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';

class GetMyProductsUseCase {
  final SellerRepository repository;

  GetMyProductsUseCase(this.repository);

  Future<List<SellerProduct>> call() {
    return repository.getMyProducts();
  }
}
