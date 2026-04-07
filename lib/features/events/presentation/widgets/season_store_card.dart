import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import '../../data/models/season_store.dart';
import 'product_item.dart';
import 'store_header.dart';

class SeasonStoreCard extends StatelessWidget {
  final SeasonStore store;

  const SeasonStoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: TColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP SECTION: Store branding with logo, name, and Visit button
          StoreHeader(store: store),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),

          // BOTTOM SECTION: Horizontal product row
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: store.products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < store.products.length - 1 ? 16 : 0,
                  ),
                  child: ProductItem(
                    product: store.products[index],
                    storeId: store.id,
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
