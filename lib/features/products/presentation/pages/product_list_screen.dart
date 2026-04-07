import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/products/presentation/providers/product_providers.dart';
import 'package:flutter_application_1/core/widgets/error_view.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المتاجر',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: asyncProducts.when(
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('لا توجد نتائج'));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (_, idx) => ProductItem(product: items[idx]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => ErrorView(
          error: err,
          onRetry: () => ref.refresh(productsFutureProvider),
        ),
      ),
    );
  }
}
