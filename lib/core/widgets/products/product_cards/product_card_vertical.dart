import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/styles/shadow_style.dart';
import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';
import 'package:flutter_application_1/core/widgets/icons/circular_icon.dart';
import 'package:flutter_application_1/core/widgets/texts/title_text.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';

class ProductCardVertical extends StatelessWidget {
  final String name;
  final String seller;
  final double price;
  final bool isDiscounted;
  final double? discountPercentage;
  final double originalPrice;
  final String image;

  const ProductCardVertical({
    required this.name,
    required this.seller,
    required this.price,
    required this.isDiscounted,
    this.discountPercentage,
    required this.originalPrice,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 197,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(Sizes.productImageRadius),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircularContainer(
              height: 180,
              padding: const EdgeInsets.all(Sizes.sm),
              color: TColors.light,
              child: Stack(
                children: [
                  // product image
                  AppImage(imageUrl: image, applyImageRadius: true),

                  // sale tag
                  if (isDiscounted && discountPercentage != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircularContainer(
                        radius: Sizes.sm,
                        color: TColors.secondary.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.sm,
                          vertical: Sizes.xs,
                        ),
                        child: Text(
                          '-${discountPercentage!.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: TColors.black,
                            fontSize: Sizes.fontMedium,
                          ),
                        ),
                      ),
                    ),

                  // favorite icon
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircularIcon(
                      dark: false,
                      icon: Icons.favorite_border,
                      color: Colors.red,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spacingBetweenItems / 2),
            // details
            Padding(
              padding: const EdgeInsets.only(left: Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: name, smallSize: true),
                  const SizedBox(height: Sizes.spacingBetweenItems / 2),
                  Row(
                    children: [
                      Text(
                        seller,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: Sizes.fontSmall,
                          color: TColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (isDiscounted)
                        Row(
                          children: [
                            Text(
                              '${price.toStringAsFixed(2)} JOD',
                              style: const TextStyle(
                                fontSize: Sizes.fontMedium,
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                              ),
                            ),
                            const SizedBox(width: Sizes.sm),
                            Text(
                              '${originalPrice.toStringAsFixed(2)} JOD',
                              style: const TextStyle(
                                fontSize: Sizes.fontSmall,
                                color: TColors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      if (!isDiscounted)
                        Row(
                          children: [
                            Text(
                              '${originalPrice.toStringAsFixed(2)} JOD',
                              style: const TextStyle(
                                fontSize: Sizes.fontSmall,
                                color: TColors.grey,
                              ),
                            ),
                          ],
                        ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          color: TColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Sizes.cardRadiusSm),
                            bottomRight: Radius.circular(
                              Sizes.productImageRadius,
                            ),
                          ),
                        ),
                        child: const SizedBox(
                          width: Sizes.iconLarge,
                          height: Sizes.iconLarge,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: TColors.white,
                              size: Sizes.iconMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
