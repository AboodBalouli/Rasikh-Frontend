import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart';
import 'package:flutter_application_1/features/custom_orders/data/datasources/custom_orders_remote_datasource.dart';
import 'package:flutter_application_1/features/custom_orders/data/repositories/custom_orders_repository_impl.dart';
import 'package:flutter_application_1/features/custom_orders/domain/repositories/custom_orders_repository.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/create_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_my_custom_orders.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_custom_order_by_id.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/update_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/cancel_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/accept_quote.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_seller_inbox.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/quote_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/reject_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/controllers/custom_orders_controller.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/controllers/seller_inbox_controller.dart';

// ============ Data Layer Providers ============

final customOrdersDatasourceProvider = Provider<CustomOrdersRemoteDatasource>((
  ref,
) {
  final client = ref.watch(httpClientProvider);
  final token = ref.watch(tokenProvider);
  return CustomOrdersRemoteDatasource(client: client, tokenProvider: token);
});

final customOrdersRepositoryProvider = Provider<CustomOrdersRepository>((ref) {
  final datasource = ref.watch(customOrdersDatasourceProvider);
  return CustomOrdersRepositoryImpl(datasource);
});

// ============ Use Case Providers ============

final createCustomOrderUseCaseProvider = Provider<CreateCustomOrder>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return CreateCustomOrder(repo);
});

final getMyCustomOrdersUseCaseProvider = Provider<GetMyCustomOrders>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return GetMyCustomOrders(repo);
});

final getCustomOrderByIdUseCaseProvider = Provider<GetCustomOrderById>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return GetCustomOrderById(repo);
});

final updateCustomOrderUseCaseProvider = Provider<UpdateCustomOrder>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return UpdateCustomOrder(repo);
});

final cancelCustomOrderUseCaseProvider = Provider<CancelCustomOrder>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return CancelCustomOrder(repo);
});

final acceptQuoteUseCaseProvider = Provider<AcceptQuote>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return AcceptQuote(repo);
});

final getSellerInboxUseCaseProvider = Provider<GetSellerInbox>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return GetSellerInbox(repo);
});

final quoteCustomOrderUseCaseProvider = Provider<QuoteCustomOrder>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return QuoteCustomOrder(repo);
});

final rejectCustomOrderUseCaseProvider = Provider<RejectCustomOrder>((ref) {
  final repo = ref.watch(customOrdersRepositoryProvider);
  return RejectCustomOrder(repo);
});

// ============ Controller Providers ============

final customOrdersControllerProvider =
    ChangeNotifierProvider<CustomOrdersController>((ref) {
      return CustomOrdersController(
        createCustomOrder: ref.watch(createCustomOrderUseCaseProvider),
        getMyCustomOrders: ref.watch(getMyCustomOrdersUseCaseProvider),
        getCustomOrderById: ref.watch(getCustomOrderByIdUseCaseProvider),
        updateCustomOrder: ref.watch(updateCustomOrderUseCaseProvider),
        cancelCustomOrder: ref.watch(cancelCustomOrderUseCaseProvider),
        acceptQuote: ref.watch(acceptQuoteUseCaseProvider),
      );
    });

final sellerInboxControllerProvider =
    ChangeNotifierProvider<SellerInboxController>((ref) {
      return SellerInboxController(
        getSellerInbox: ref.watch(getSellerInboxUseCaseProvider),
        quoteCustomOrder: ref.watch(quoteCustomOrderUseCaseProvider),
        rejectCustomOrder: ref.watch(rejectCustomOrderUseCaseProvider),
      );
    });
