import 'package:flutter/material.dart';
// import 'package:flutter_application_1/core/constants/sizes.dart';
// import 'package:flutter_application_1/core/utils/temp_pics.dart';
import 'package:flutter_application_1/features/public_orders/presentation/widgets/products_gridview.dart';
// import 'package:flutter_application_1/features/public_orders/presentation/widgets/public_order_product.dart';
import 'package:flutter_application_1/features/public_orders/presentation/widgets/public_orders_page_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

class PublicOrdersPage extends ConsumerWidget {
  const PublicOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PublicOrdersPageAppbar(),
      body: ProductsGridView(),
    );
  }
}
