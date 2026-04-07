import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_application_1/features/orders/domain/entities/create_order_request.dart';
import 'package:flutter_application_1/features/orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final double totalPrice;

  const CheckoutPage({super.key, required this.totalPrice});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  int _selectedPaymentMethod = 0; // 0: Cash, 1: Wallet

  final _formKey = GlobalKey<FormState>();
  final _shippingAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _shippingAddressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_isPlacingOrder) return;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final usecase = ref.read(createOrderUseCaseProvider);
      await usecase(
        CreateOrderRequest(
          shippingAddress: _shippingAddressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );

      ref.invalidate(myOrdersProvider);
      ref.invalidate(myOrdersCountProvider);

      // Best-effort: clear cart after placing an order.
      try {
        final clearCart = ref.read(clearCartUseCaseProvider);
        await clearCart();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إنشاء الطلب ولكن فشل تفريغ السلة: $e')),
          );
        }
      } finally {
        ref.invalidate(myCartProvider);
        ref.invalidate(cartItemsCountProvider);
      }

      if (mounted) {
        context.go('/order-sent');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل إنشاء الطلب: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: CustomBackButton()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.paddingAll(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(),
                SizedBox(height: context.hp(2)),
                Text(
                  'بيانات الشحن',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 83, 125, 93),
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.parastoo,
                  ),
                ),
                SizedBox(height: context.hp(1.2)),
                TextFormField(
                  controller: _shippingAddressController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الشحن',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل عنوان الشحن';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.hp(1.2)),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'من فضلك أدخل رقم الهاتف';
                    if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(v)) {
                      return 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079 ويتكون من 10 أرقام';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.hp(1.2)),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),

                SizedBox(height: context.hp(2.5)),
                Text(
                  AppStrings.payVia,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 83, 125, 93),
                    fontSize: context.sp(19),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.parastoo,
                  ),
                ),
                SizedBox(height: context.hp(2)),
                _buildPaymentOption(0, AppStrings.cash, Icons.money),
                SizedBox(height: context.hp(1.5)),
                _buildPaymentOption(
                  1,
                  AppStrings.rasikhWallet,
                  Icons.account_balance_wallet,
                ),
                SizedBox(height: context.hp(2)),

                Text(
                  AppStrings.paymentSummary,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 83, 125, 93),
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.parastoo,
                  ),
                ),
                SizedBox(height: context.hp(1.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.totalAmount,
                      style: TextStyle(
                        fontSize: context.sp(15),
                        color: Colors.grey,
                        fontFamily: AppFonts.parastoo,
                      ),
                    ),
                    Text(
                      "\$${widget.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: context.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE3A428),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.hp(3)),
                Container(
                  height: context.hp(6.5), // Responsive height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 202, 224, 197),
                        Color.fromARGB(255, 83, 125, 93),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          162,
                          173,
                          171,
                        ).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isPlacingOrder ? null : _placeOrder,
                      borderRadius: BorderRadius.circular(30),
                      child: Center(
                        child: _isPlacingOrder
                            ? SizedBox(
                                width: context.hp(2.5),
                                height: context.hp(2.5),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppStrings.placeOrder,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.sp(16),
                                  fontFamily: AppFonts.parastoo,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.hp(2)), // Extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: Responsive.paddingAll(context, factor: 0.7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 83, 125, 93)
                : const Color.fromARGB(255, 202, 224, 197),
            width: isSelected ? 2 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color.fromARGB(255, 83, 125, 93)
                  : const Color.fromARGB(255, 161, 182, 156),
              size: context.sp(24),
            ),
            SizedBox(width: context.wp(4)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.parastoo,
                  color: isSelected
                      ? const Color.fromARGB(255, 83, 125, 93)
                      : const Color.fromARGB(255, 161, 182, 156),
                ),
              ),
            ),
            Container(
              width: context.sp(24),
              height: context.sp(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color.fromARGB(255, 202, 224, 197)
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: context.sp(12),
                        height: context.sp(12),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 83, 125, 93),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
