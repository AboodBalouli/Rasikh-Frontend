import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'package:flutter_application_1/core/utils/helpers/helper_functions.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_application_1/features/public_orders/presentation/widgets/open_whatsapp_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PublicOrderDetailsPage extends ConsumerWidget {
  final String orderId;
  final bool canManage;

  const PublicOrderDetailsPage({
    super.key,
    required this.orderId,
    required this.canManage,
  });

  String _displayStatus(String status) {
    switch (status) {
      case 'DISPLAYED':
        return 'معروض';
      case 'COMPLETED':
        return 'تم الطلب';
      default:
        return status;
    }
  }

  String? _resolveImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return null;

    final trimmed = imageUrl.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      final host = uri.host.toLowerCase();
      if (host == 'example.com' || host.endsWith('.example.com')) {
        return null;
      }
    }

    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return trimmed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(publicOrderByIdProvider(orderId));
    const primaryGreen = Color.fromARGB(255, 83, 148, 93);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              leading: const CustomBackButton(),
              title: const Text(
                'تفاصيل الطلب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryGreen,
                ),
              ),
              centerTitle: true,
              actions: canManage
                  ? [
                      IconButton(
                        tooltip: 'تعديل',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          context.push('/edit-public-order/$orderId');
                        },
                      ),
                      IconButton(
                        tooltip: 'Mark completed',
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () async {
                          try {
                            final updateStatus = ref.read(
                              updatePublicOrderStatusUseCaseProvider,
                            );
                            await updateStatus(
                              id: orderId,
                              status: 'COMPLETED',
                            );

                            ref.invalidate(publicOrderByIdProvider(orderId));
                            ref.invalidate(myPublicOrdersProvider);
                            ref.invalidate(myPublicOrdersCountProvider);
                            ref.invalidate(publicOrdersFeedControllerProvider);
                            ref.invalidate(
                              publicOrdersByStatusFeedControllerProvider(
                                'DISPLAYED',
                              ),
                            );
                            ref.invalidate(
                              publicOrdersByStatusFeedControllerProvider(
                                'COMPLETED',
                              ),
                            );

                            if (!context.mounted) return;
                            SnackbarHelper.showSnackBar(
                              'Order marked as completed',
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            SnackbarHelper.showSnackBar(
                              e.toString(),
                              isError: true,
                            );
                          }
                        },
                      ),
                      IconButton(
                        tooltip: 'حذف',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          try {
                            final del = ref.read(
                              deletePublicOrderUseCaseProvider,
                            );
                            await del(orderId);

                            ref.invalidate(myPublicOrdersProvider);
                            ref.invalidate(myPublicOrdersCountProvider);
                            ref.invalidate(publicOrdersFeedControllerProvider);
                            ref.invalidate(
                              publicOrdersByStatusFeedControllerProvider(
                                'DISPLAYED',
                              ),
                            );
                            ref.invalidate(
                              publicOrdersByStatusFeedControllerProvider(
                                'COMPLETED',
                              ),
                            );

                            if (!context.mounted) return;
                            SnackbarHelper.showSnackBar(
                              'Order deleted successfully',
                            );
                            context.pop();
                          } catch (e) {
                            if (!context.mounted) return;
                            SnackbarHelper.showSnackBar(
                              e.toString(),
                              isError: true,
                            );
                          }
                        },
                      ),
                    ]
                  : const [],
            ),
          ),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 83, 148, 93),
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(e.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (order) {
          const primaryGreen = Color.fromARGB(255, 83, 148, 93);
          final directImageUrl = _resolveImageUrl(order.imageUrl);
          final firstImagePathAsync = directImageUrl == null
              ? ref.watch(publicOrderFirstImagePathProvider(order.id))
              : null;

          final imageUrl =
              directImageUrl ??
              firstImagePathAsync?.when(
                data: (path) => _resolveImageUrl(path),
                loading: () => null,
                error: (_, __) => null,
              );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: kToolbarHeight + 16),

              // Image Card with Glass Effect
              if (imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AppImage(
                            imageUrl: imageUrl,
                            applyImageRadius: false,
                            fit: BoxFit.cover,
                            isNetworkImage: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Title and Status Card
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryGreen.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _displayStatus(order.status),
                            style: const TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          HelperFunctions.timeAgo(order.orderDate),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Card
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الوصف',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contact Information Card
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.contact_phone_outlined,
                          color: primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'معلومات التواصل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'الموقع',
                      value: order.location,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      title: 'الهاتف',
                      value: order.phoneNumber,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      title: 'العميل',
                      value:
                          '${order.customerFirstName} ${order.customerLastName}'
                              .trim(),
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // WhatsApp Button Card
              _buildGlassCard(
                child: OpenWhatsappButton(whatsappUrl: order.whatsappUrl),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    const primaryGreen = Color.fromARGB(255, 83, 148, 93);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
