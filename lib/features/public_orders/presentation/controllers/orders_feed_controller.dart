import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_riverpod/legacy.dart';

typedef FetchOrdersPage =
    Future<List<PublicOrder>> Function(int pageNumber, int pageSize);

class OrdersFeedState {
  final List<PublicOrder> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int nextPageNumber;
  final Object? error;

  const OrdersFeedState({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.nextPageNumber,
    required this.error,
  });

  const OrdersFeedState.initial()
    : items = const [],
      isLoading = true,
      isLoadingMore = false,
      hasMore = true,
      nextPageNumber = 0,
      error = null;

  OrdersFeedState copyWith({
    List<PublicOrder>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? nextPageNumber,
    Object? error,
  }) {
    return OrdersFeedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextPageNumber: nextPageNumber ?? this.nextPageNumber,
      error: error,
    );
  }
}

class OrdersFeedController extends StateNotifier<OrdersFeedState> {
  final FetchOrdersPage _fetchPage;
  final int _pageSize;

  OrdersFeedController({required FetchOrdersPage fetchPage, int pageSize = 10})
    : _fetchPage = fetchPage,
      _pageSize = pageSize,
      super(const OrdersFeedState.initial()) {
    // Kick off initial load.
    Future.microtask(refresh);
  }

  Future<void> refresh() async {
    state = state.copyWith(
      items: const [],
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      nextPageNumber: 0,
      error: null,
    );

    try {
      final items = await _fetchPage(0, _pageSize);
      state = state.copyWith(
        items: items,
        isLoading: false,
        isLoadingMore: false,
        hasMore: items.length == _pageSize,
        nextPageNumber: 1,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final pageNumber = state.nextPageNumber;
      final newItems = await _fetchPage(pageNumber, _pageSize);
      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoadingMore: false,
        hasMore: newItems.length == _pageSize,
        nextPageNumber: pageNumber + 1,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}
