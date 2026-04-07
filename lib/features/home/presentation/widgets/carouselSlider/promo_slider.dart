import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';
import 'package:flutter_application_1/features/seasons/data/models/promo_banner.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({super.key, required this.banners});

  final List<PromoBanner> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

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
                onPageChanged: (index, reason) =>
                    controller.updatePageIndicator(index),
              ),
              items: banners.map((banner) {
                return GestureDetector(
                  onTap: () {
                    final key = banner.seasonKey.isNotEmpty
                        ? banner.seasonKey
                        : 'default';
                    context.go('/season/$key');
                  },
                  child: AppImage(imageUrl: banner.imageUrl),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  CircularContainer(
                    width: 20,
                    height: 5,
                    margin: const EdgeInsets.only(right: 10),
                    color: controller.carouselCurrentIndex.value == i
                        ? Colors.black
                        : Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
