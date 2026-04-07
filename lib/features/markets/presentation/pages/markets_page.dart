import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_config.dart';
import '../providers/markets_providers.dart';
import '../widgets/market_store_card.dart';

class MarketsPage extends ConsumerStatefulWidget {
  final String? initialCategoryName;
  final int? initialCategoryId;
  final String title;

  const MarketsPage({
    super.key,
    required this.title,
    this.initialCategoryName,
    this.initialCategoryId,
  });

  @override
  ConsumerState<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends ConsumerState<MarketsPage> {
  bool _bootstrapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;

    final controller = ref.read(marketsControllerProvider);
    controller.setInitialCategoryIfNeeded(widget.initialCategoryName);
    controller.setTargetCategoryId(widget.initialCategoryId);
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(marketsControllerProvider);
    final stores = controller.filteredStores;
    final availableTags = controller.availableTags;
    final isFilteredByCategory = controller.isFilteredByCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث... ',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.setSearchQuery,
            ),
          ),

          // Categories Filter - only show when not filtered by a specific category
          if (!isFilteredByCategory)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: controller.selectedCategory == category,
                      onSelected: (_) => controller.setCategory(category),
                    ),
                  );
                },
              ),
            ),

          // Tags Filter Section Header - shown when filtering by category
          if (isFilteredByCategory && availableTags.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    size: 20,
                    color: Color.fromARGB(255, 83, 148, 93),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ترتيب حسب التصنيف:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (controller.selectedTag != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.selectTag(null),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مسح الفلتر',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.close, size: 14, color: Colors.red[700]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Tags Filter Chips - only show if there are tags available
          if (availableTags.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: availableTags.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: const Text('الكل'),
                        selected: controller.selectedTag == null,
                        selectedColor: const Color.fromARGB(
                          255,
                          83,
                          148,
                          93,
                        ).withValues(alpha: 0.2),
                        onSelected: (selected) {
                          if (selected) controller.selectTag(null);
                        },
                      ),
                    );
                  }
                  final tag = availableTags[index - 1];
                  final isSelected = controller.selectedTag == tag;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      selectedColor: const Color.fromARGB(
                        255,
                        83,
                        148,
                        93,
                      ).withValues(alpha: 0.2),
                      onSelected: (selected) {
                        controller.selectTag(selected ? tag : null);
                      },
                    ),
                  );
                },
              ),
            ),

          // Store count indicator
          if (!controller.isLoading && controller.error == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${stores.length} متجر',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (controller.selectedTag != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          83,
                          148,
                          93,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.selectedTag!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 83, 148, 93),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(controller.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.load,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : stores.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.selectedTag != null
                              ? 'لا توجد متاجر بهذا التصنيف'
                              : 'لا توجد متاجر حالياً',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (controller.selectedTag != null) ...[
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => controller.selectTag(null),
                            child: const Text('عرض جميع المتاجر'),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      final imagePath = store.profilePictureUrl?.trim();
                      final imageUrl =
                          (imagePath != null && imagePath.isNotEmpty)
                          ? '${AppConfig.apiBaseUrl}$imagePath'
                          : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MarketStoreCard(
                          storeName: store.sellerName,
                          imageUrl: imageUrl,
                          rating: store.averageRating ?? 0.0,
                          reviewsCount: store.ratingCount ?? 0,
                          // workHours: store.workingHours ?? '9am - 5pm',
                          government: store.government ?? '',
                          discountText: null,
                          onTap: () {
                            context.push('/seller/${store.profileId}');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
