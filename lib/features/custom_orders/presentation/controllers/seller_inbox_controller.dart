import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/get_seller_inbox.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/quote_custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/usecases/reject_custom_order.dart';

/// Controller for seller-side custom order operations.
class SellerInboxController extends ChangeNotifier {
  final GetSellerInbox _getSellerInbox;
  final QuoteCustomOrder _quoteCustomOrder;
  final RejectCustomOrder _rejectCustomOrder;

  SellerInboxController({
    required GetSellerInbox getSellerInbox,
    required QuoteCustomOrder quoteCustomOrder,
    required RejectCustomOrder rejectCustomOrder,
  }) : _getSellerInbox = getSellerInbox,
       _quoteCustomOrder = quoteCustomOrder,
       _rejectCustomOrder = rejectCustomOrder;

  List<CustomOrder> _inbox = [];
  CustomOrder? _selectedOrder;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<CustomOrder> get inbox => _inbox;
  CustomOrder? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  /// Number of pending requests in inbox.
  int get pendingCount => _inbox.where((o) => o.status.canQuote).length;

  /// Load seller's inbox.
  Future<void> loadInbox() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _inbox = await _getSellerInbox();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Select an order for viewing/quoting.
  void selectOrder(CustomOrder order) {
    _selectedOrder = order;
    notifyListeners();
  }

  /// Quote a custom order.
  Future<bool> quote({
    required String id,
    required double quotedPrice,
    required int estimatedDays,
    String? sellerNote,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final quoted = await _quoteCustomOrder(
        id: id,
        quotedPrice: quotedPrice,
        estimatedDays: estimatedDays,
        sellerNote: sellerNote,
      );

      final idx = _inbox.indexWhere((o) => o.id == id);
      if (idx >= 0) {
        _inbox[idx] = quoted;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = quoted;
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

  /// Reject a custom order.
  Future<bool> reject(String id) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final rejected = await _rejectCustomOrder(id);

      final idx = _inbox.indexWhere((o) => o.id == id);
      if (idx >= 0) {
        _inbox[idx] = rejected;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = rejected;
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
