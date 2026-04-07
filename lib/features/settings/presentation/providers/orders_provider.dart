import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/order_model.dart';

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier()
    : super([
        OrderModel(
          id: "1",
          customerName: "أحمد", // موجود
          type: "طلب عادي", // تأكد من وجوده
          status: "جديد", // موجود
          details: "سلة قش", // تأكد من وجوده
          date: "2024-01-07", // تأكد من وجوده
          price: "25.00",
          isSpecial: true,
        ),
        OrderModel(
          id: "1",
          customerName: "أحمد", // موجود
          type: "طلب عادي", // تأكد من وجوده
          status: "جديد", // موجود
          details: "سلة قش", // تأكد من وجوده
          date: "2024-01-07", // تأكد من وجوده
          price: "25.00",
          isSpecial: true,
        ),
        OrderModel(
          id: "1",
          customerName: "أحمد", // موجود
          type: "طلب عادي", // تأكد من وجوده
          status: "جديد", // موجود
          details: "سلة قش", // تأكد من وجوده
          date: "2024-01-07", // تأكد من وجوده
          price: "25.00",
          isSpecial: true,
        ),
      ]);

  void updateStatus(String orderId, String newStatus) {
    state = [
      for (final order in state)
        if (order.id == orderId) order.copyWith(status: newStatus) else order,
    ];
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>((
  ref,
) {
  return OrdersNotifier();
});
