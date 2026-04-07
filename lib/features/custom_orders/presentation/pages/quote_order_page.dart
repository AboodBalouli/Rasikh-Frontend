import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

/// Page for sellers to quote a custom order request.
class QuoteOrderPage extends ConsumerStatefulWidget {
  final String orderId;

  const QuoteOrderPage({super.key, required this.orderId});

  @override
  ConsumerState<QuoteOrderPage> createState() => _QuoteOrderPageState();
}

class _QuoteOrderPageState extends ConsumerState<QuoteOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _daysController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _daysController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text) ?? 0;
    final days = int.tryParse(_daysController.text) ?? 1;

    final controller = ref.read(sellerInboxControllerProvider);
    final success = await controller.quote(
      id: widget.orderId,
      quotedPrice: price,
      estimatedDays: days,
      sellerNote: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال التسعير بنجاح', style: GoogleFonts.cairo()),
          backgroundColor: const Color(0xFF53945D),
        ),
      );
      context.pop();
    } else if (controller.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error!, style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'رفض الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من رفض هذا الطلب؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'رفض',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final controller = ref.read(sellerInboxControllerProvider);
    final success = await controller.reject(widget.orderId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم رفض الطلب', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(sellerInboxControllerProvider);
    final order = controller.selectedOrder;

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'تسعير الطلب',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: Responsive.paddingAll(context),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order summary card
              if (order != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.wp(4)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.title,
                        style: GoogleFonts.cairo(
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: context.hp(1)),
                      Text(
                        order.description,
                        style: GoogleFonts.cairo(
                          fontSize: context.sp(14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: context.hp(2)),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: context.sp(16),
                            color: Colors.grey,
                          ),
                          SizedBox(width: context.wp(1)),
                          Text(
                            order.customerFullName,
                            style: GoogleFonts.cairo(
                              fontSize: context.sp(13),
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.location_on_outlined,
                            size: context.sp(16),
                            color: Colors.grey,
                          ),
                          SizedBox(width: context.wp(1)),
                          Text(
                            order.location,
                            style: GoogleFonts.cairo(
                              fontSize: context.sp(13),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.hp(3)),
              ],

              // Price field
              Text(
                'السعر (JOD)',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'السعر مطلوب';
                  final price = double.tryParse(v);
                  if (price == null || price <= 0) return 'أدخل سعراً صالحاً';
                  return null;
                },
              ),

              SizedBox(height: context.hp(2.5)),

              // Estimated days field
              Text(
                'مدة التوصيل (بالأيام)',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: InputDecoration(
                  hintText: '3',
                  prefixIcon: const Icon(Icons.schedule),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مدة التوصيل مطلوبة';
                  final days = int.tryParse(v);
                  if (days == null || days <= 0) return 'أدخل عدد أيام صالح';
                  return null;
                },
              ),

              SizedBox(height: context.hp(2.5)),

              // Note field
              Text(
                'ملاحظة للعميل (اختياري)',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'مثال: يمكن التعديل على التصميم حسب الطلب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              SizedBox(height: context.hp(4)),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: context.hp(7),
                child: ElevatedButton(
                  onPressed: controller.isSaving ? null : _submitQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53945D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'إرسال التسعير',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: context.hp(2)),

              // Reject button
              SizedBox(
                width: double.infinity,
                height: context.hp(7),
                child: OutlinedButton(
                  onPressed: controller.isSaving ? null : _rejectOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'رفض الطلب',
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
