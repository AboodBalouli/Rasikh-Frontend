import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';

import '../providers/organization_provider.dart';
import '../widgets/organization_card.dart';

class OrganizationsCategoryPage extends ConsumerWidget {
  const OrganizationsCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationsAsync = ref.watch(organizationsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CustomBackButton(),
            const Spacer(),
            const Text(
              'الجمعيات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 83, 148, 93),
              ),
            ),
          ],
        ),
      ),
      body: organizationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('حدث خطأ، حاول مرة اخرى')),
        data: (organizations) {
          final approved = organizations.where((o) => o.isApproved).toList();

          return approved.isEmpty
              ? const Center(child: Text('لا توجد جمعيات'))
              : ListView.builder(
                  itemCount: approved.length,
                  itemBuilder: (context, index) {
                    final org = approved[index];
                    return OrganizationCard(
                      organization: org,
                      onTap: () => context.push('/organizations/${org.id}'),
                    );
                  },
                );
        },
      ),
    );
  }
}
