import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_application_1/features/categories/data/repositories/category_repository_impl.dart';
import 'package:flutter_application_1/features/categories/domain/entities/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});

final categoriesProvider = FutureProvider<List<Categrory>>((ref) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.getCategories();
});
