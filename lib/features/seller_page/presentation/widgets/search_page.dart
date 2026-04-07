import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/entities/product_card_model.dart';

enum SearchType { stores, associations, crafts }

class SearchPage extends StatefulWidget {
  final SearchType searchType;
  final String initialCategory;

  const SearchPage({
    super.key,
    required this.searchType,
    this.initialCategory = 'الكل',
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  late String activeMainCategory;
  String? activeSubCategory;
  late Future<List<ProductCardModel>> futureProducts;

  // 1. بيانات المتاجر
  final Map<String, List<String>> storeCategories = {
    'طعام': ['حلويات', 'ساندويشات', 'دجاج', 'عربي', 'مشروبات'],
    'بقالة': ['خضروات', 'ألبان', 'منظفات', 'معلبات'],
    'صحة': ['عناية', 'فيتامينات', 'أجهزة طبية'],
    'هدايا': ['ورد', 'ساعات', 'عطور'],
  };

  // 2. بيانات الجمعيات
  final Map<String, List<String>> associationCategories = {
    'إنساني': ['خيرية', 'أيتام', 'إطعام', 'كسوة'],
    'رعاية': ['ذوي إعاقة', 'كبار السن', 'تأهيل'],
    'مجتمع': ['تمكين المرأة', 'شباب', 'بيئة'],
  };

  // 3. بيانات الحرف اليدوية
  final Map<String, List<String>> craftCategories = {
    'خياطة': ['تطريز', 'تصميم', 'تعديل', 'خياطة يدوية'],
    'شموع': ['شموع عطرية', 'شموع ديكور', 'هدايا شموع'],
    'رسم': ['لوحات', 'جداريات'],
    'نجارة': ['أثاث', 'تصليح'],
  };

  @override
  void initState() {
    super.initState();
    _resetFilters();
    futureProducts = _fetchProductsFromApi();
  }

  void _resetFilters() {
    activeMainCategory = widget.initialCategory;
    activeSubCategory = null;
  }

  Map<String, List<String>> get currentMap {
    if (widget.searchType == SearchType.crafts) return craftCategories;
    if (widget.searchType == SearchType.associations)
      return associationCategories;
    return storeCategories;
  }

  Future<List<ProductCardModel>> _fetchProductsFromApi() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return []; //  تربط مع الباك آند
  }

  IconData _getIcon(String category) {
    if (category == 'الكل') return Icons.grid_view_rounded;
    if (widget.searchType == SearchType.crafts) {
      switch (category) {
        case 'خياطة':
          return Icons.content_cut;
        case 'شموع':
          return Icons.lightbulb;
        case 'رسم':
          return Icons.palette;
        default:
          return Icons.brush;
      }
    }
    if (widget.searchType == SearchType.associations)
      return Icons.volunteer_activism;
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterArea(),
            const Divider(height: 10, thickness: 0.5),
            Expanded(
              child: FutureBuilder<List<ProductCardModel>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }
                  final allProducts = snapshot.data ?? [];
                  final filtered = allProducts.where((p) {
                    final mQuery = p.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    );
                    final mMain =
                        activeMainCategory == 'الكل' ||
                        p.category == activeMainCategory;
                    final mSub =
                        activeSubCategory == null ||
                        (p.tags?.contains(activeSubCategory!) ?? false);
                    return mQuery && mMain && mSub;
                  }).toList();

                  return _buildResultList(filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterArea() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: activeMainCategory == 'الكل'
            ? _buildMainCategoryList(key: ValueKey('main_${widget.searchType}'))
            : _buildSubCategoryList(key: ValueKey('sub_$activeMainCategory')),
      ),
    );
  }

  Widget _buildMainCategoryList({required Key key}) {
    final mainKeys = ['الكل', ...currentMap.keys];
    return ListView.builder(
      key: key,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: mainKeys.length,
      itemBuilder: (context, index) {
        final cat = mainKeys[index];
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ChoiceChip(
            avatar: Icon(_getIcon(cat), size: 16),
            label: Text(cat),
            selected: activeMainCategory == cat,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  activeMainCategory = cat;
                  activeSubCategory = null;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSubCategoryList({required Key key}) {
    final subs = currentMap[activeMainCategory] ?? [];
    return ListView(
      key: key,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        ActionChip(
          avatar: const Icon(Icons.arrow_forward_ios, size: 12),
          label: const Text("رجوع"),
          onPressed: () => setState(() => activeMainCategory = 'الكل'),
        ),
        const SizedBox(width: 8),
        ...subs.map(
          (sub) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(sub),
              selected: activeSubCategory == sub,
              onSelected: (val) =>
                  setState(() => activeSubCategory = val ? sub : null),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: "بحث...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList(List<ProductCardModel> items) {
    if (items.isEmpty) return const Center(child: Text("لا توجد نتائج"));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItemCard(items[index]),
    );
  }

  Widget _buildItemCard(ProductCardModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: item.imagePath != null
              ? Image.network(item.imagePath!, width: 80, fit: BoxFit.cover)
              : Container(width: 80, color: Colors.grey[200]),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.category ?? ""),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
