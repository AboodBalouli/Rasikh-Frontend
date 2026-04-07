import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/settings/data/models/payment_method.dart';

class PaymentMethodsNotifier extends Notifier<List<PaymentMethod>> {
  @override
  List<PaymentMethod> build() {
    return [
      PaymentMethod(
        id: '3',
        title: 'Cash on Delivery',
        subtitle: 'الدفع عند الاستلام',
      ),
    ];
  }

  void addMethod(PaymentMethod method) {
    state = [...state, method];
  }

  void removeMethod(String id) {
    state = state.where((m) => m.id != id).toList();
  }
}

final paymentMethodsProvider =
    NotifierProvider<PaymentMethodsNotifier, List<PaymentMethod>>(
      () => PaymentMethodsNotifier(),
    );
