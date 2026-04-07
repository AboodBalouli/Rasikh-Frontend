import 'package:flutter_application_1/app/dependency_injection/orders_dependency_injection.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_status.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/fetch_my_orders_by_status_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/fetch_my_orders_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/fetch_order_by_id_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/get_my_orders_count_usecase.dart';
import 'package:flutter_application_1/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchMyOrdersUseCaseProvider = Provider<FetchMyOrdersUseCase>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return FetchMyOrdersUseCase(repo);
});

final fetchMyOrdersByStatusUseCaseProvider =
    Provider<FetchMyOrdersByStatusUseCase>((ref) {
      final repo = ref.watch(ordersRepositoryProvider);
      return FetchMyOrdersByStatusUseCase(repo);
    });

final fetchOrderByIdUseCaseProvider = Provider<FetchOrderByIdUseCase>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return FetchOrderByIdUseCase(repo);
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return CreateOrderUseCase(repo);
});

final updateOrderStatusUseCaseProvider = Provider<UpdateOrderStatusUseCase>((
  ref,
) {
  final repo = ref.watch(ordersRepositoryProvider);
  return UpdateOrderStatusUseCase(repo);
});

final cancelOrderUseCaseProvider = Provider<CancelOrderUseCase>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return CancelOrderUseCase(repo);
});

final deleteOrderUseCaseProvider = Provider<DeleteOrderUseCase>((ref) {
  final repo = ref.watch(ordersRepositoryProvider);
  return DeleteOrderUseCase(repo);
});

final getMyOrdersCountUseCaseProvider = Provider<GetMyOrdersCountUseCase>((
  ref,
) {
  final repo = ref.watch(ordersRepositoryProvider);
  return GetMyOrdersCountUseCase(repo);
});

final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final usecase = ref.watch(fetchMyOrdersUseCaseProvider);
  return usecase();
});

final myOrdersByStatusProvider =
    FutureProvider.family<List<Order>, OrderStatus>((ref, status) async {
      final usecase = ref.watch(fetchMyOrdersByStatusUseCaseProvider);
      return usecase(status);
    });

final myOrdersCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getMyOrdersCountUseCaseProvider);
  return usecase();
});

final orderByIdProvider = FutureProvider.family<Order, int>((
  ref,
  orderId,
) async {
  final usecase = ref.watch(fetchOrderByIdUseCaseProvider);
  return usecase(orderId);
});
