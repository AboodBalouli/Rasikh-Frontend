import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';
import '../../data/models/order_model.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الطلبات',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'جديدة'),
            Tab(text: 'قيد التنفيذ'),
            Tab(text: 'مكتملة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilteredList(allOrders, 'جديد'),
          _buildFilteredList(allOrders, 'قيد التنفيذ'),
          _buildFilteredList(allOrders, 'مكتمل'),
        ],
      ),
    );
  }

  Widget _buildFilteredList(List<OrderModel> orders, String status) {
    final filtered = orders.where((o) => o.status == status).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final order = filtered[index];

        final bool isSpecial = order.isSpecial;

        return Card(
          color: isSpecial ? Colors.orange.shade50 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSpecial
                ? const BorderSide(color: Colors.orange, width: 2)
                : BorderSide.none,
          ),

          elevation: isSpecial ? 5 : 2,
          margin: const EdgeInsets.symmetric(vertical: 8),

          child: ListTile(
            title: Row(
              children: [
                Text('طلب #${order.id} - ${order.customerName}'),
                if (isSpecial) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.orange, size: 20),
                ],
              ],
            ),
            subtitle: Text(
              'المنتج: ${order.details}\nالسعر: ${order.price} JOD',
              style: TextStyle(
                fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: _buildActionButton(order),
          ),
        );
      },
    );
  }

  Widget? _buildActionButton(OrderModel order) {
    if (order.status == 'جديد') {
      return ElevatedButton(
        onPressed: () => ref
            .read(ordersProvider.notifier)
            .updateStatus(order.id, 'قيد التنفيذ'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text('قبول'),
      );
    } else if (order.status == 'قيد التنفيذ') {
      return ElevatedButton(
        onPressed: () =>
            ref.read(ordersProvider.notifier).updateStatus(order.id, 'مكتمل'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text('تم التوصيل'),
      );
    }
    return null;
  }
}
