import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/presentation/providers/events_providers.dart';
import 'package:flutter_application_1/features/events/presentation/widgets/event_product_card.dart';
import 'package:flutter_application_1/features/events/presentation/widgets/event_store_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page displaying event details with participating stores and related products.
class EventDetailPage extends ConsumerWidget {
  final int eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final participatingStoresAsync = ref.watch(
      participatingStoresProvider(eventId),
    );
    final eventProductsAsync = ref.watch(eventProductsProvider(eventId));

    return Scaffold(
      backgroundColor: TColors.light,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: TColors.primary),
            onPressed: () => context.go('/home'),
            tooltip: 'العودة للرئيسية',
          ),
        ),
        title: eventAsync.when(
          data: (event) => Text(
            event.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: TColors.primary,
            ),
          ),
          loading: () => const Text('جاري التحميل...'),
          error: (_, __) => const Text('الموسم'),
        ),
        backgroundColor: TColors.white,
        foregroundColor: TColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: eventAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: TColors.primary),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: TColors.error),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل البيانات',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref.invalidate(eventByIdProvider(eventId));
                    ref.invalidate(participatingStoresProvider(eventId));
                    ref.invalidate(eventProductsProvider(eventId));
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
          data: (event) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventByIdProvider(eventId));
              ref.invalidate(participatingStoresProvider(eventId));
              ref.invalidate(eventProductsProvider(eventId));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Event header
                SliverToBoxAdapter(child: _buildEventHeader(event)),

                // Participating stores section
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    'المتاجر المشاركة',
                    Icons.verified,
                    TColors.primary,
                  ),
                ),
                participatingStoresAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TColors.primary,
                        ),
                      ),
                    ),
                  ),
                  error: (_, __) => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('خطأ في تحميل المتاجر')),
                    ),
                  ),
                  data: (stores) {
                    if (stores.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Center(
                            child: Text(
                              'لا توجد متاجر مشاركة حتى الآن',
                              style: TextStyle(
                                fontSize: 14,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => EventStoreCard(
                            store: stores[index],
                            isParticipating: true,
                          ),
                          childCount: stores.length,
                        ),
                      ),
                    );
                  },
                ),

                // Related products section
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    'منتجات مرتبطة بالموسم',
                    Icons.shopping_bag_outlined,
                    TColors.darkerGrey,
                  ),
                ),
                eventProductsAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TColors.primary,
                        ),
                      ),
                    ),
                  ),
                  error: (_, __) => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('خطأ في تحميل المنتجات')),
                    ),
                  ),
                  data: (eventProducts) {
                    final products = eventProducts.products;
                    if (products.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Center(
                            child: Text(
                              'لا توجد منتجات مرتبطة بهذا الموسم',
                              style: TextStyle(
                                fontSize: 14,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < products.length - 1 ? 12 : 0,
                              ),
                              child: EventProductCard(product: products[index]),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader(Event event) {
    String? imageUrl = event.imageUrl;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${AppConfig.apiBaseUrl}$imageUrl';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Event image
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: TColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.event,
                    size: 64,
                    color: TColors.primary,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: TColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event, size: 48, color: TColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Event description
          if (event.description != null && event.description!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: TColors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                event.description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: TColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          // Event dates
          if (event.startDate != null || event.endDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: TColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateRange(event.startDate, event.endDate),
                    style: const TextStyle(
                      fontSize: 13,
                      color: TColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: TColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '';

    String formatDate(DateTime dt) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }

    if (start != null && end != null) {
      return '${formatDate(start)} - ${formatDate(end)}';
    } else if (start != null) {
      return 'من ${formatDate(start)}';
    } else {
      return 'حتى ${formatDate(end!)}';
    }
  }
}
