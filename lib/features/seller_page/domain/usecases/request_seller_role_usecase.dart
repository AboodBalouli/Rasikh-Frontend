import 'dart:typed_data';
import '../repositories/seller_repository.dart';
import '../entities/role_change_request.dart';

class RequestSellerRoleUseCase {
  final SellerRepository repository;

  RequestSellerRoleUseCase(this.repository);

  Future<RoleChangeRequest> call({
    required int categoryId,
    required List<Uint8List> proofs,
    String? note,
    Uint8List? certificate,
  }) {
    return repository.requestSellerRole(
      categoryId: categoryId,
      proofs: proofs,
      note: note,
      certificate: certificate,
    );
  }
}
