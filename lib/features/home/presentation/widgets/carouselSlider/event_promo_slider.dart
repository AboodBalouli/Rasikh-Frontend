import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';
import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/presentation/providers/events_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Carousel slider that displays events from the backend.
class EventPromoSlider extends ConsumerStatefulWidget {
  const EventPromoSlider({super.key});

  @override
  ConsumerState<EventPromoSlider> createState() => _EventPromoSliderState();
}

class _EventPromoSliderState extends ConsumerState<EventPromoSlider> {
  int _currentIndex = 0;

  void _updatePageIndicator(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String? _buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${AppConfig.apiBaseUrl}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return eventsAsync.when(
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildErrorState(),
      data: (events) {
        if (events.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildCarousel(events);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      height: 180,
      decoration: BoxDecoration(
        color: TColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: TColors.primary),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      height: 180,
      decoration: BoxDecoration(
        color: TColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event, size: 48, color: TColors.primary),
            const SizedBox(height: 8),
            const Text(
              'لا توجد مواسم حالياً',
              style: TextStyle(fontSize: 16, color: TColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(upcomingEventsProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<Event> events) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 25,
                spreadRadius: 3,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) => _updatePageIndicator(index),
              ),
              items: events.map((event) {
                return GestureDetector(
                  onTap: () => context.push('/event/${event.id}'),
                  child: _buildEventBanner(event),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < events.length; i++)
                CircularContainer(
                  width: 20,
                  height: 5,
                  margin: const EdgeInsets.only(right: 10),
                  color: _currentIndex == i ? Colors.black : Colors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventBanner(Event event) {
    final imageUrl = _buildImageUrl(event.imageUrl);

    if (imageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallbackBanner(event),
          ),
          // Gradient overlay for text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                event.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _buildFallbackBanner(event);
  }

  Widget _buildFallbackBanner(Event event) {
    return Container(
      color: TColors.primary.withValues(alpha: 0.15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event, size: 48, color: TColors.primary),
            const SizedBox(height: 12),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (event.description != null && event.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  event.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: TColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
