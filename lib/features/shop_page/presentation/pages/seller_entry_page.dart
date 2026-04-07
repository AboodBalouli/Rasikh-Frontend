import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/main_shop_page.dart';

class SellerEntryPage extends StatelessWidget {
  final String storeId;

  const SellerEntryPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return MainShopPage(storeId: storeId);
  }
}
