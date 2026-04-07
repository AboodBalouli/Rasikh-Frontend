import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/largeCategories/crafts_container.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/largeCategories/food_container.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/largeCategories/organization_container.dart';

class LargeCategoriesContainer extends StatelessWidget {
  const LargeCategoriesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OrganizationContainer(),
        SizedBox(height: Sizes.sm),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.sm),
          child: Row(
            children: [
              Expanded(child: FoodContainer()),
              SizedBox(width: Sizes.sm),
              Expanded(child: CraftsContainer()),
            ],
          ),
        ),
      ],
    );
  }
}
