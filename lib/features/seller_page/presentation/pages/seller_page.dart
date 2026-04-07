import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/seller_page/presentation/widgets/seller_banner.dart';
import 'package:flutter_application_1/core/entities/product_card_model.dart';
import 'package:flutter_application_1/features/products/presentation/widgets/product_card.dart';
import '../providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// هون بدك تستدعي صفحة السيرش الي تتغير تتلقائيا حسب البوتون الي نختاره : اكل / حرف / جمعيات
//import 'package:flutter_application_1/features/seller/presentation/widgets/search_page.dart';

class SellerPage extends ConsumerStatefulWidget {
  const SellerPage({super.key});

  @override
  ConsumerState<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends ConsumerState<SellerPage> {
  List<ProductCardModel> _products = [];

  Future<void> _addNewProduct() async {
    final result = await context.push('/add-product');
    
    // If product was added successfully, refresh the products list from backend
    if (result == true) {
      // Clear local cache and refresh from backend to get all images
      setState(() => _products = []);
      ref.invalidate(productsProvider);
    } else if (result != null && result is Map<String, dynamic>) {
      // Legacy: manual product insertion (kept for backwards compatibility)
      setState(() {
        _products.insert(
          0,
          ProductCardModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            imagePath: result['imagePath'] as String?,
            imageFile: result['imageFile'],
            title: result['title'] ?? 'منتج جديد',
            price: result['price'] ?? '',
            originalPrice: result['originalPrice'] ?? result['price'] ?? '',
            description: result['description'] as String?,
            category: result['category'] as String?,
            tags: result['tags'] != null
                ? List<String>.from(result['tags'] as List)
                : <String>[],
            imagePaths: result['imagePaths'] != null
                ? List<String>.from(result['imagePaths'] as List)
                : null,
          ),
        );
      });
    }
  }

  Future<void> _editProduct(ProductCardModel product) async {
    final result = await context.push('/edit-product', extra: product);

    if (!mounted) return;

    // If product was edited successfully, refresh products from backend
    if (result == true) {
      setState(() => _products = []);
      ref.invalidate(productsProvider);
      return;
    }

    // Legacy: manual product update (kept for backwards compatibility)
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        product.title = result['title'] as String? ?? product.title;
        product.price = result['price'] as String? ?? product.price;
        product.originalPrice =
            result['price'] as String? ?? product.originalPrice;

        product.description =
            result['description'] as String? ?? product.description;

        if (result['tags'] != null) {
          try {
            product.tags = List<String>.from(result['tags'] as List);
          } catch (_) {}
        }

        final newImageFile = result['imageFile'];
        if (newImageFile != null) {
          product.imageFile = newImageFile;
          product.imagePath = null;
        } else {
          final newImagePath = result['imagePath'] as String?;
          if (newImagePath != null) {
            product.imagePath = newImagePath;
            product.imageFile = null;
          }
        }
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تم تحديث المنتج بنجاح")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final Color bannerColor = Theme.of(context).colorScheme.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: bannerColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: const Color.fromARGB(255, 83, 148, 93),
          actions: [
            IconButton(
              tooltip: 'الحساب',
              icon: const Icon(
                Icons.person_outline,
                color: Color.fromARGB(255, 83, 148, 93),
              ),
              iconSize: 30,
              onPressed: () {
                context.push('/account-info');
              },
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: productsAsync.when(
          data: (products) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsProvider);
              setState(() => _products = []);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SellerBannerNew()),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: Responsive.paddingH(
                      context,
                    ).copyWith(top: context.hp(1.2), bottom: context.hp(1.8)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'منتجاتي',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _addNewProduct,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "إضافة منتج",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Builder(
                  builder: (context) {
                    if (_products.isEmpty && products.isNotEmpty) {
                      _products = List<ProductCardModel>.from(products);
                    }

                    return _products.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'لا توجد منتجات حالياً.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 4,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final product = _products[index];
                                return ProductCard(
                                  productCardModel: product,
                                  onDelete: () {
                                    setState(() => _products.remove(product));
                                  },
                                  onHide: () {
                                    setState(
                                      () => product.hidden = !product.hidden,
                                    );
                                  },
                                  onEdit: () => _editProduct(product),
                                  onUpdateDiscount: (newPrice) {
                                    setState(() {
                                      final value = newPrice.trim();
                                      if (value.isEmpty) {
                                        product.discountPrice = null;
                                        product.isDiscounted = false;
                                      } else {
                                        product.discountPrice = value;
                                        product.isDiscounted = true;
                                      }
                                    });
                                  },
                                );
                              }, childCount: _products.length),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
          // حالة التحميل (Loading): تظهر بدلاً من الـ body بالكامل عند فتح الصفحة
          loading: () => const Center(child: CircularProgressIndicator()),

          // حالة الخطأ (Error): تظهر إذا فشل الربط مع الباك إند
          error: (err, stack) =>
              Center(child: Text("حدث خطأ أثناء جلب البيانات: $err")),
        ),
      ),
    );
  }
}
