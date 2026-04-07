import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/payment_methods_provider.dart';
import '/features/products/presentation/providers/providers.dart';
import '/features/settings/data/models/payment_method.dart';

class PaymentMethodsPage extends ConsumerWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentMethodsProvider);
    final userType = ref.watch(userTypeProvider);
    final bool isCharity = userType == UserType.charity;

    // تحديد اللون بناءً على نوع الحساب
    final Color activeColor = isCharity
        ? Colors.green[700]!
        : Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'طرق الدفع',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: methods.isEmpty
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text('تحديد طرق الدفع', style: GoogleFonts.cairo()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    _showPaymentTypeFullScreen(context, ref, activeColor),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: methods.length,
                      itemBuilder: (context, index) {
                        final method = methods[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Icon(
                              method.title.contains('محفظة')
                                  ? Icons.account_balance_wallet
                                  : Icons.money,
                              color: activeColor,
                            ),
                            title: Text(
                              method.title,
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              method.subtitle,
                              style: GoogleFonts.cairo(),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red[400]),
                              onPressed: () {
                                ref
                                    .read(paymentMethodsProvider.notifier)
                                    .removeMethod(method.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon: Icon(Icons.add, color: activeColor),
                    label: Text(
                      'إضافة طريقة دفع أخرى',
                      style: GoogleFonts.cairo(
                        color: activeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () =>
                        _showPaymentTypeFullScreen(context, ref, activeColor),
                  ),
                ],
              ),
            ),
    );
  }

  void _showPaymentTypeFullScreen(
    BuildContext context,
    WidgetRef ref,
    Color activeColor,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختر طريقة الدفع',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.account_balance_wallet, color: activeColor),
                title: Text('محفظة راسخ', style: GoogleFonts.cairo()),
                onTap: () {
                  context.pop();
                  _showAddWalletDialog(context, ref, activeColor);
                },
              ),
              ListTile(
                leading: Icon(Icons.money, color: activeColor),
                title: Text('الدفع عند الاستلام', style: GoogleFonts.cairo()),
                onTap: () {
                  context.pop();
                  _addCashOnDelivery(ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddWalletDialog(
    BuildContext context,
    WidgetRef ref,
    Color activeColor,
  ) {
    final walletNumberController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إضافة محفظة',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: walletNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'رقم المحفظة',
                  labelStyle: GoogleFonts.cairo(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: activeColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: activeColor),
                  onPressed: () {
                    final newWallet = PaymentMethod(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: 'محفظة راسخ ',

                      subtitle: walletNumberController.text,
                    );
                    ref
                        .read(paymentMethodsProvider.notifier)
                        .addMethod(newWallet);
                    context.pop();
                  },
                  child: Text(
                    'إضافة',
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCashOnDelivery(WidgetRef ref) {
    final newMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'الدفع عند الاستلام',
      subtitle: 'الدفع عند استلام الطلب',
    );
    ref.read(paymentMethodsProvider.notifier).addMethod(newMethod);
  }
}
