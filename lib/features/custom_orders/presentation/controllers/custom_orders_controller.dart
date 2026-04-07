import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/create_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_my_custom_orders.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_custom_order_by_id.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/update_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/cancel_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/accept_quote.dart';

/// Controller for customer-side custom order operations.
class CustomOrdersController extends ChangeNotifier {
  final CreateCustomOrder _createCustomOrder;
  final GetMyCustomOrders _getMyCustomOrders;
  final GetCustomOrderById _getCustomOrderById;
  final UpdateCustomOrder _updateCustomOrder;
  final CancelCustomOrder _cancelCustomOrder;
  final AcceptQuote _acceptQuote;

  CustomOrdersController({
    required CreateCustomOrder createCustomOrder,
    required GetMyCustomOrders getMyCustomOrders,
    required GetCustomOrderById getCustomOrderById,
    required UpdateCustomOrder updateCustomOrder,
    required CancelCustomOrder cancelCustomOrder,
    required AcceptQuote acceptQuote,
  }) : _createCustomOrder = createCustomOrder,
       _getMyCustomOrders = getMyCustomOrders,
       _getCustomOrderById = getCustomOrderById,
       _updateCustomOrder = updateCustomOrder,
       _cancelCustomOrder = cancelCustomOrder,
       _acceptQuote = acceptQuote;

  List<CustomOrder> _orders = [];
  CustomOrder? _selectedOrder;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<CustomOrder> get orders => _orders;
  CustomOrder? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  /// Load customer's custom orders.
  Future<void> loadMyOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _getMyCustomOrders();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load a single order by ID.
  Future<void> loadOrderById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedOrder = await _getCustomOrderById(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new custom order.
  Future<CustomOrder?> create({
    required String sellerProfileId,
    required String title,
    required String description,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
    List<String>? imagePaths,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final order = await _createCustomOrder(
        sellerProfileId: sellerProfileId,
        title: title,
        description: description,
        location: location,
        phoneNumber: phoneNumber,
        whatsappUrl: whatsappUrl,
        imagePaths: imagePaths,
      );

      _orders = [order, ..._orders];
      _isSaving = false;
      notifyListeners();
      return order;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return null;
    }
  }

  /// Update an existing custom order (only when PENDING).
  Future<bool> update({
    required String id,
    String? title,
    String? description,
    String? location,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _updateCustomOrder(
        id: id,
        title: title,
        description: description,
        location: location,
      );

      final idx = _orders.indexWhere((o) => o.id == id);
      if (idx >= 0) {
        _orders[idx] = updated;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = updated;
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Cancel a custom order.
  Future<bool> cancel(String id) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final canceled = await _cancelCustomOrder(id);

      final idx = _orders.indexWhere((o) => o.id == id);
      if (idx >= 0) {
        _orders[idx] = canceled;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = canceled;
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Accept a seller's quote.
  Future<bool> acceptOrderQuote(String id) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final accepted = await _acceptQuote(id);

      final idx = _orders.indexWhere((o) => o.id == id);
      if (idx >= 0) {
        _orders[idx] = accepted;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = accepted;
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
