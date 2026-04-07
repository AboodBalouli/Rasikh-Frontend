import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PastOrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PastOrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('الطلبات السابقة'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.push('/past-orders');
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
