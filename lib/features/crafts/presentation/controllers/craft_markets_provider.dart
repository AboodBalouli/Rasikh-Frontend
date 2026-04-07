import 'package:flutter/material.dart';

import '../../domain/entities/craft_market.dart';
import '../../domain/repositories/craft_markets_repository.dart';

class CraftMarketsProvider extends ChangeNotifier {
  final CraftMarketsRepository repository;

  CraftMarketsProvider(this.repository);

  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final uniqueCategories = repository
        .getMarkets()
        .map((e) => e.category)
        .toSet()
        .toList();

    uniqueCategories.sort();
    return ['الكل', ...uniqueCategories];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<CraftMarket> get filteredMarkets {
    return repository.getMarkets().where((market) {
      final matchesSearch = market.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesCategory =
          _selectedCategory == 'الكل' ||
          market.category.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }
}
