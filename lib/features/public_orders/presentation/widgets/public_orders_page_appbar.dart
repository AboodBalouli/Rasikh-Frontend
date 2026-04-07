import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class PublicOrdersPageAppbar extends ConsumerWidget
    implements PreferredSizeWidget {
  const PublicOrdersPageAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(publicOrdersFeedModeProvider);
    final myCountAsync = ref.watch(myPublicOrdersCountProvider);
    final searchQuery = ref.watch(publicOrdersSearchQueryProvider);

    String title;
    switch (mode) {
      case PublicOrdersFeedMode.all:
        title = 'الطلبات العامة';
        break;
      case PublicOrdersFeedMode.displayed:
        title = 'Displayed Orders';
        break;
      case PublicOrdersFeedMode.completed:
        title = 'Completed Orders';
        break;
      case PublicOrdersFeedMode.mine:
        title = 'My Orders';
        break;
    }

    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              title,
              style: TextStyle(
                fontSize: context.sp(20),
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 83, 148, 93),
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.wp(4),
                  0,
                  context.wp(4),
                  context.hp(1.5),
                ),
                child: TextField(
                  onChanged: (value) {
                    ref.read(publicOrdersSearchQueryProvider.notifier).state =
                        value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search title or description',
                    hintStyle: TextStyle(fontSize: context.sp(14)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 83, 148, 93),
                      size: context.sp(24),
                    ),
                    suffixIcon: searchQuery.trim().isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear',
                            icon: Icon(
                              Icons.close,
                              color: Colors.black54,
                              size: context.sp(22),
                            ),
                            onPressed: () {
                              ref
                                      .read(
                                        publicOrdersSearchQueryProvider
                                            .notifier,
                                      )
                                      .state =
                                  '';
                            },
                          ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.wp(3),
                      vertical: context.hp(1.5),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              myCountAsync.when(
                data: (count) => Padding(
                  padding: EdgeInsets.only(right: context.wp(1)),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.wp(2.5),
                        vertical: context.hp(0.8),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$count',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: context.sp(12),
                        ),
                      ),
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              PopupMenuButton<PublicOrdersFeedMode>(
                tooltip: 'Filter',
                initialValue: mode,
                onSelected: (value) {
                  ref.read(publicOrdersFeedModeProvider.notifier).state = value;
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: PublicOrdersFeedMode.all,
                    child: Text('All'),
                  ),
                  PopupMenuItem(
                    value: PublicOrdersFeedMode.displayed,
                    child: Text('Displayed'),
                  ),
                  PopupMenuItem(
                    value: PublicOrdersFeedMode.completed,
                    child: Text('Completed'),
                  ),
                  PopupMenuItem(
                    value: PublicOrdersFeedMode.mine,
                    child: Text('My orders'),
                  ),
                ],
                icon: Icon(Icons.filter_list, size: context.sp(24)),
              ),
              IconButton(
                onPressed: () => context.push('/create-public-order'),
                icon: Icon(Icons.add, size: context.sp(24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
