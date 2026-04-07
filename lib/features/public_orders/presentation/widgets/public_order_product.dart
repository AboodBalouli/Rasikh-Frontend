import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';

import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';

import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/utils/helpers/helper_functions.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/core/utils/temp_pics.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class PublicOrderProduct extends ConsumerWidget {
  final PublicOrder order;

  const PublicOrderProduct({required this.order, super.key});

  static const int _maxTitleChars = 50;

  String _truncate(String value, int maxChars) {
    final trimmed = value.trim();
    if (trimmed.length <= maxChars) return trimmed;
    return '${trimmed.substring(0, maxChars).trimRight()}…';
  }

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return const Color.fromARGB(255, 255, 152, 0); // Orange
      case 'DISPLAYED':
        return const Color.fromARGB(255, 83, 148, 93); // Green
      default:
        return Colors.grey;
    }
  }

  String _resolveImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return TempPics.fallbackImage;
    }

    final trimmed = imageUrl.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      final host = uri.host.toLowerCase();
      if (host == 'example.com' || host.endsWith('.example.com')) {
        return TempPics.fallbackImage;
      }
    }

    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return trimmed;
  }

  bool _isPlaceholderUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return true;
    final trimmed = imageUrl.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      final host = uri.host.toLowerCase();
      return host == 'example.com' || host.endsWith('.example.com');
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(publicOrdersFeedModeProvider);
    final canManage = mode == PublicOrdersFeedMode.mine;
    final updateStatus = ref.read(updatePublicOrderStatusUseCaseProvider);
    final deleteOrder = ref.read(deletePublicOrderUseCaseProvider);

    Future<void> markCompleted() async {
      try {
        await updateStatus(id: order.id, status: 'COMPLETED');
        ref.invalidate(myPublicOrdersProvider);
        ref.invalidate(myPublicOrdersCountProvider);
        ref.invalidate(publicOrdersFeedControllerProvider);
        ref.invalidate(publicOrdersByStatusFeedControllerProvider('DISPLAYED'));
        ref.invalidate(publicOrdersByStatusFeedControllerProvider('COMPLETED'));
        if (!context.mounted) return;
        SnackbarHelper.showSnackBar('Order marked as completed');
      } catch (e) {
        if (!context.mounted) return;
        SnackbarHelper.showSnackBar(e.toString(), isError: true);
      }
    }

    Future<void> delete() async {
      try {
        await deleteOrder(order.id);
        ref.invalidate(myPublicOrdersProvider);
        ref.invalidate(myPublicOrdersCountProvider);
        ref.invalidate(publicOrdersFeedControllerProvider);
        ref.invalidate(publicOrdersByStatusFeedControllerProvider('DISPLAYED'));
        ref.invalidate(publicOrdersByStatusFeedControllerProvider('COMPLETED'));
        if (!context.mounted) return;
        SnackbarHelper.showSnackBar('Order deleted successfully');
      } catch (e) {
        if (!context.mounted) return;
        SnackbarHelper.showSnackBar(e.toString(), isError: true);
      }
    }

    final shouldUseImagesEndpoint = _isPlaceholderUrl(order.imageUrl);
    final firstImagePathAsync = shouldUseImagesEndpoint
        ? ref.watch(publicOrderFirstImagePathProvider(order.id))
        : null;

    final imageUrl = firstImagePathAsync == null
        ? _resolveImageUrl(order.imageUrl)
        : firstImagePathAsync.when(
            data: (path) =>
                path == null ? TempPics.fallbackImage : _resolveImageUrl(path),
            loading: () => TempPics.fallbackImage,
            error: (_, __) => TempPics.fallbackImage,
          );

    return GestureDetector(
      onTap: () {
        final mode = ref.read(publicOrdersFeedModeProvider);
        context.push(
          '/public-orders/${order.id}',
          extra: mode == PublicOrdersFeedMode.mine,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.sp(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(context.sp(16)),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularContainer(
                  height: context.hp(15),
                  padding: EdgeInsets.all(context.wp(2)),
                  color: TColors.light,
                  child: Stack(
                    children: [
                      // product image
                      AppImage(
                        imageUrl: imageUrl,
                        applyImageRadius: true,
                        fit: BoxFit.cover,
                      ),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: canManage
                            ? PopupMenuButton<String>(
                                tooltip: 'Actions',
                                onSelected: (value) {
                                  switch (value) {
                                    case 'complete':
                                      markCompleted();
                                      break;
                                    case 'delete':
                                      delete();
                                      break;
                                    case 'edit':
                                      context.push(
                                        '/edit-public-order/${order.id}',
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'complete',
                                    child: Text('Mark completed'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                child: Container(
                                  padding: EdgeInsets.all(context.wp(1.5)),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.scrim.withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: context.sp(18),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.hp(1)),
                // details
                Padding(
                  padding: EdgeInsets.only(left: context.wp(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Using SizedBox / Text instead of TitleText to be safe with responsiveness or overriding standard widget if needed,
                      // or just wrapping. TitleText custom widget might need its own audit, but for now I'll use it assuming it's standard.
                      // Actually, let's keep TitleText but maybe check its props. It takes 'smallSize'.
                      // I will replace it with responsive Text to be sure.
                      Text(
                        _truncate(order.title, _maxTitleChars),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: context.sp(14),
                        ),
                      ),
                      SizedBox(height: context.hp(0.8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.wp(2),
                          vertical: context.hp(0.5),
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            order.status,
                          ).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(
                              order.status,
                            ).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _displayStatus(order.status),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: context.sp(12),
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: context.hp(0.5)),
                      Text(
                        HelperFunctions.timeAgo(order.orderDate),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: context.sp(12),
                          color: TColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
