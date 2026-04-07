import '../entities/category.dart';

/// Domain repository for categories. Implementations may fetch from
/// local data or remote backend.
abstract class CategoryRepository {
  Future<List<Categrory>> getCategories();
}
