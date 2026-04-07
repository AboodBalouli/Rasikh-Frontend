import '../entities/create_order_request.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';

abstract class OrdersRepository {
  Future<Order> createOrder(CreateOrderRequest request);
  Future<List<Order>> fetchMyOrders();
  Future<List<Order>> fetchMyOrdersByStatus(OrderStatus status);
  Future<Order> fetchOrderById(int orderId);
  Future<Order> updateOrderStatus({
    required int orderId,
    required OrderStatus newStatus,
  });
  Future<Order> cancelOrder(int orderId);
  Future<void> deleteOrder(int orderId);
  Future<int> getMyOrdersCount();
}
