import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_application_1/app/dependency_injection/public_orders_dependency_injection.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/create_public_order_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/delete_public_order_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/fetch_public_order_by_id_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/fetch_public_orders.page.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/fetch_my_public_orders_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/fetch_public_orders_by_status_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/get_my_orders_count_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/fetch_public_order_image_paths_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/update_order_status.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/update_public_order_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/upload_public_order_images_usecase.dart';
import 'package:flutter_application_1/features/public_orders/presentation/controllers/orders_feed_controller.dart';
import 'package:flutter_application_1/features/public_orders/presentation/controllers/create_public_order_controller.dart';
import 'package:flutter_application_1/features/public_orders/presentation/controllers/create_public_order_state.dart';

enum PublicOrdersFeedMode { all, displayed, completed, mine }

final publicOrdersFeedModeProvider = StateProvider<PublicOrdersFeedMode>((ref) {
  return PublicOrdersFeedMode.all;
});

/// Search query for public orders (filters by title + description).
final publicOrdersSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

// 5) Usecases: "actions" the UI can call
final fetchPublicOrdersUseCaseProvider = Provider<FetchPublicOrdersUseCase>((
  ref,
) {
  final repo = ref.watch(publicOrdersRepositoryProvider);
  return FetchPublicOrdersUseCase(repo);
});

final fetchPublicOrderByIdUseCaseProvider =
    Provider<FetchPublicOrderByIdUseCase>((ref) {
      final repo = ref.watch(publicOrdersRepositoryProvider);
      return FetchPublicOrderByIdUseCase(repo);
    });

final createPublicOrderUseCaseProvider = Provider<CreatePublicOrderUseCase>((
  ref,
) {
  final repo = ref.watch(publicOrdersRepositoryProvider);
  return CreatePublicOrderUseCase(repo);
});

final uploadPublicOrderImagesUseCaseProvider =
    Provider<UploadPublicOrderImagesUseCase>((ref) {
      final repo = ref.watch(publicOrdersRepositoryProvider);
      return UploadPublicOrderImagesUseCase(repo);
    });

final updatePublicOrderUseCaseProvider = Provider<UpdatePublicOrderUseCase>((
  ref,
) {
  final repo = ref.watch(publicOrdersRepositoryProvider);
  return UpdatePublicOrderUseCase(repo);
});

final updatePublicOrderStatusUseCaseProvider =
    Provider<UpdatePublicOrderStatusUseCase>((ref) {
      final repo = ref.watch(publicOrdersRepositoryProvider);
      return UpdatePublicOrderStatusUseCase(repo);
    });

final deletePublicOrderUseCaseProvider = Provider<DeletePublicOrderUseCase>((
  ref,
) {
  final repo = ref.watch(publicOrdersRepositoryProvider);
  return DeletePublicOrderUseCase(repo);
});

final fetchMyPublicOrdersUseCaseProvider = Provider<FetchMyPublicOrdersUseCase>(
  (ref) {
    final repo = ref.watch(publicOrdersRepositoryProvider);
    return FetchMyPublicOrdersUseCase(repo);
  },
);

final fetchPublicOrdersByStatusUseCaseProvider =
    Provider<FetchPublicOrdersByStatusUseCase>((ref) {
      final repo = ref.watch(publicOrdersRepositoryProvider);
      return FetchPublicOrdersByStatusUseCase(repo);
    });

final getMyOrdersCountUseCaseProvider = Provider<GetMyOrdersCountUseCase>((
  ref,
) {
  final repo = ref.watch(publicOrdersRepositoryProvider);
  return GetMyOrdersCountUseCase(repo);
});

final fetchPublicOrderImagePathsUseCaseProvider =
    Provider<FetchPublicOrderImagePathsUseCase>((ref) {
      final repo = ref.watch(publicOrdersRepositoryProvider);
      return FetchPublicOrderImagePathsUseCase(repo);
    });

final createPublicOrderControllerProvider =
    StateNotifierProvider.autoDispose<
      CreatePublicOrderController,
      CreatePublicOrderState
    >((ref) {
      final createUsecase = ref.watch(createPublicOrderUseCaseProvider);
      final updateUsecase = ref.watch(updatePublicOrderUseCaseProvider);
      final uploadImages = ref.watch(uploadPublicOrderImagesUseCaseProvider);
      return CreatePublicOrderController(
        createUsecase,
        updateUsecase,
        uploadImages,
      );
    });

/// Fetches a single page of public orders.
///
/// Usage: `ref.watch(publicOrdersPageProvider((pageNumber: 0, pageSize: 10)))`
final publicOrdersPageProvider =
    FutureProvider.family<List<PublicOrder>, ({int pageNumber, int pageSize})>((
      ref,
      params,
    ) async {
      final usecase = ref.watch(fetchPublicOrdersUseCaseProvider);
      return usecase(pageNumber: params.pageNumber, pageSize: params.pageSize);
    });

/// Infinite-scroll feed for **all** public orders.
///
/// Uses pageNumber/pageSize under the hood and appends items.
final publicOrdersFeedControllerProvider =
    StateNotifierProvider.autoDispose<OrdersFeedController, OrdersFeedState>((
      ref,
    ) {
      final usecase = ref.watch(fetchPublicOrdersUseCaseProvider);
      return OrdersFeedController(
        pageSize: 10,
        fetchPage: (pageNumber, pageSize) =>
            usecase(pageNumber: pageNumber, pageSize: pageSize),
      );
    });

/// Infinite-scroll feed for public orders by a given status (e.g. DISPLAYED/COMPLETED).
final publicOrdersByStatusFeedControllerProvider = StateNotifierProvider
    .autoDispose
    .family<OrdersFeedController, OrdersFeedState, String>((ref, status) {
      final usecase = ref.watch(fetchPublicOrdersByStatusUseCaseProvider);
      return OrdersFeedController(
        pageSize: 10,
        fetchPage: (pageNumber, pageSize) =>
            usecase(status: status, pageNumber: pageNumber, pageSize: pageSize),
      );
    });

final publicOrderByIdProvider = FutureProvider.family<PublicOrder, String>((
  ref,
  id,
) async {
  final usecase = ref.watch(fetchPublicOrderByIdUseCaseProvider);
  return usecase(id);
});

final myPublicOrdersProvider = FutureProvider<List<PublicOrder>>((ref) async {
  final usecase = ref.watch(fetchMyPublicOrdersUseCaseProvider);
  return usecase();
});

final publicOrdersByStatusProvider =
    FutureProvider.family<
      List<PublicOrder>,
      ({String status, int pageNumber, int pageSize})
    >((ref, params) async {
      final usecase = ref.watch(fetchPublicOrdersByStatusUseCaseProvider);
      return usecase(
        status: params.status,
        pageNumber: params.pageNumber,
        pageSize: params.pageSize,
      );
    });

final myPublicOrdersCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getMyOrdersCountUseCaseProvider);
  return usecase();
});

/// First image path for an order (if any) from the images endpoint.
final publicOrderFirstImagePathProvider =
    FutureProvider.family<String?, String>((ref, publicOrderId) async {
      final usecase = ref.watch(fetchPublicOrderImagePathsUseCaseProvider);
      final paths = await usecase(publicOrderId);
      if (paths.isEmpty) return null;
      return paths.first;
    });
