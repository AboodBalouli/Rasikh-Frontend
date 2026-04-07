import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';

class EmptyOrdersState extends ConsumerWidget {
  const EmptyOrdersState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);

    return Center(
      child: Padding(
        padding: Responsive.paddingAll(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: context.sp(80),
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            SizedBox(height: context.hp(3)),
            Text(
              AppStrings.noPreviousOrders,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.sp(18),
              ),
            ),
            SizedBox(height: context.hp(1)),
            Text(
              AppStrings.ordersWillAppearHere,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: context.sp(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
