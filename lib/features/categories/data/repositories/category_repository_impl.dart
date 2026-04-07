import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../dummy_data.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  /// Currently returns in-memory dummy categories. Replace with
  /// remote calls when backend is available.
  @override
  Future<List<Categrory>> getCategories() async {
    // simulate small delay like a network request
    await Future.delayed(const Duration(milliseconds: 100));
    return dummyCategories;
  }
}
