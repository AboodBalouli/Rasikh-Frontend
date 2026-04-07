import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/features/organization/presentation/controllers/admin_dashboard_controller.dart';
import 'package:flutter_application_1/features/organization/presentation/widgets/admin_product_card.dart';

/// Admin Products Screen - Main dashboard for managing organization products.
/// Shows a list of products with edit and delete options.
class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key, this.organizationId});

  final String? organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardControllerProvider);
    final controller = ref.read(adminDashboardControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Products List
            _buildProductsList(context, state, controller, ref),
            // Floating Add Button
            _buildFloatingAddButton(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border(
                bottom: BorderSide(
                  color: const Color.fromARGB(
                    255,
                    83,
                    148,
                    93,
                  ).withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
      ),
      leading: const CustomBackButton(),
      title: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(adminDashboardControllerProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إدارة المنتجات',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${state.products.length} منتج',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        // Settings Button
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => context.push('/organization-admin/edit-info'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      83,
                      148,
                      93,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        83,
                        148,
                        93,
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 20,
                    color: Color.fromARGB(255, 83, 148, 93),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      toolbarHeight: 72,
    );
  }

  Widget _buildProductsList(
    BuildContext context,
    AdminDashboardState state,
    AdminDashboardController controller,
    WidgetRef ref,
  ) {
    // Show loading state
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (state.error != null && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل المنتجات',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => controller.refreshProducts(),
              child: Text(
                'إعادة المحاولة',
                style: GoogleFonts.cairo(color: const Color(0xFF030213)),
              ),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات بعد',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط على زر الإضافة لإضافة منتج جديد',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }

    // Show products list
    return RefreshIndicator(
      onRefresh: () => controller.refreshProducts(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return AdminProductCard(
            product: product,
            onEdit: () {
              context.push('/organization-admin/edit-product/${product.id}');
            },
            onToggleVisibility: () async {
              try {
                await controller.toggleProductVisibility(product.id);
                if (context.mounted) {
                  final message = product.isVisible
                      ? 'تم إخفاء "${product.name}" بنجاح'
                      : 'تم إظهار "${product.name}" بنجاح';
                  _showSuccessSnackBar(context, message);
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorSnackBar(context, 'فشل تحديث حالة المنتج: $e');
                }
              }
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    String productName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'حذف المنتج',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'هل أنت متأكد من حذف "$productName"؟',
            style: GoogleFonts.cairo(),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text('إلغاء', style: GoogleFonts.cairo()),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('حذف', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(message, style: GoogleFonts.cairo()),
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(message, style: GoogleFonts.cairo()),
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.85),
                  Colors.white.withOpacity(0),
                ],
                stops: const [0, 0.7, 1],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/organization-admin/add-product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 148, 93),
                    foregroundColor: Colors.white,
                    elevation: 12,
                    shadowColor: const Color.fromARGB(
                      255,
                      83,
                      148,
                      93,
                    ).withOpacity(0.4),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'إضافة منتج جديد',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
