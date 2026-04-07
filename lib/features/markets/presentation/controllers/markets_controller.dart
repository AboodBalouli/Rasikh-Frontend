import 'package:flutter/material.dart';

import '../../domain/entities/market_store.dart';
import '../../domain/usecases/get_all_stores_usecase.dart';

class MarketsController extends ChangeNotifier {
  final GetAllStoresUsecase getAllStores;

  MarketsController({required this.getAllStores});

  bool _isLoading = false;
  String? _error;
  List<MarketStore> _stores = const [];

  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  int? _targetCategoryId;
  String? _selectedTag;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<MarketStore> get stores => _stores;

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int? get targetCategoryId => _targetCategoryId;
  String? get selectedTag => _selectedTag;

  List<String> get categories {
    // If targetCategoryId is set, we generally don't need to show other categories,
    // but we can still return them if we want the user to be able to switch (unlikely per requirements).
    // For now, if targetCategoryId is set, let's just return 'الكل' and the specific category name if found?
    // Actually, existing logic derives from _stores. Let's keep it but filteredStores will respect targetCategoryId.

    final sourceStores = _targetCategoryId != null
        ? _stores.where((s) => s.categoryId == _targetCategoryId)
        : _stores;

    final unique = sourceStores
        .map((e) => e.categoryName)
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    unique.sort();
    return ['الكل', ...unique];
  }

  // Get available tags for the current filtered view (ignoring tag selection itself)
  List<String> get availableTags {
    final q = _searchQuery.trim().toLowerCase();

    // Filter by search and category first
    final preFiltered = _stores.where((s) {
      if (_targetCategoryId != null && s.categoryId != _targetCategoryId) {
        return false;
      }

      final matchesSearch =
          q.isEmpty ||
          s.sellerName.toLowerCase().contains(q) ||
          (s.address ?? '').toLowerCase().contains(q);

      // Also respect the textual category selection if targetId is not set or matches?
      // If targetId is set, _selectedCategory usually stays 'الكل' unless user changes it.
      final c = _selectedCategory.trim().toLowerCase();
      final matchesCategoryName =
          c == 'الكل' || (s.categoryName ?? '').toLowerCase() == c;

      return matchesSearch && matchesCategoryName;
    });

    final tags = preFiltered.expand((s) => s.tags).toSet().toList();
    tags.sort();
    return tags;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _selectedTag = null; // Reset tag when category changes
    notifyListeners();
  }

  void setInitialCategoryIfNeeded(String? categoryName) {
    final c = categoryName?.trim();
    if (c == null || c.isEmpty) return;
    if (_selectedCategory != 'الكل') return;
    _selectedCategory = c;
  }

  void setTargetCategoryId(int? id) {
    // Set the target category ID without notifying (will be done after load)
    _targetCategoryId = id;
    _selectedTag = null;
    _selectedCategory = 'الكل';
    // Don't call notifyListeners here - load() will do it
  }

  /// Check if this controller is filtering by a specific category
  bool get isFilteredByCategory => _targetCategoryId != null;

  /// Get the name of the current category being filtered (if any)
  String? get currentCategoryName {
    if (_targetCategoryId == null) return null;
    final store = _stores.firstWhere(
      (s) => s.categoryId == _targetCategoryId,
      orElse: () => const MarketStore(profileId: 0, userId: 0, sellerName: ''),
    );
    return store.categoryName;
  }

  void selectTag(String? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stores = await getAllStores();
    } catch (e) {
      _error = 'تعذر تحميل المتاجر';
    }

    _isLoading = false;
    notifyListeners();
  }

  List<MarketStore> get filteredStores {
    final q = _searchQuery.trim().toLowerCase();
    return _stores.where((s) {
      if (_targetCategoryId != null && s.categoryId != _targetCategoryId) {
        return false;
      }

      final matchesSearch =
          q.isEmpty ||
          s.sellerName.toLowerCase().contains(q) ||
          (s.address ?? '').toLowerCase().contains(q);

      final c = _selectedCategory.trim().toLowerCase();
      final matchesCategory =
          c == 'الكل' || (s.categoryName ?? '').toLowerCase() == c;

      final matchesTag = _selectedTag == null || s.tags.contains(_selectedTag);

      return matchesSearch && matchesCategory && matchesTag;
    }).toList();
  }
}
