import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import '../pages/create_custom_order_page.dart';

/// Section for displaying and creating custom order requests to a seller.
class SpecialOrdersSection extends ConsumerWidget {
  final String sellerProfileId;
  final String sellerStoreName;

  const SpecialOrdersSection({
    super.key,
    required this.sellerProfileId,
    required this.sellerStoreName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عندك طلب خاص ؟',
            style: GoogleFonts.cairo(
              fontSize: context.sp(22),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: context.hp(0.5)),
          Text(
            'أرسل طلبك المخصص للبائع مباشرة',
            style: GoogleFonts.cairo(
              fontSize: context.sp(14),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: context.hp(2.5)),

          // Create order button
          GestureDetector(
            onTap: () {
              context.push(
                '/create-custom-order',
                extra: CreateCustomOrderPageArgs(
                  sellerProfileId: sellerProfileId,
                  sellerStoreName: sellerStoreName,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(context.wp(4)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF53945D),
                    const Color(0xFF53945D).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF53945D).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.wp(3)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: context.sp(24),
                    ),
                  ),
                  SizedBox(width: context.wp(4)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إنشاء طلب مخصص',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'صف طلبك وستحصل على عرض سعر',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(12),
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8),
                    size: context.sp(18),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: context.hp(3)),

          // Link to view my custom orders
          Center(
            child: TextButton.icon(
              onPressed: () => context.push('/my-custom-orders'),
              icon: Icon(
                Icons.history,
                size: context.sp(18),
                color: const Color(0xFF53945D),
              ),
              label: Text(
                'عرض طلباتي الخاصة',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(14),
                  color: const Color(0xFF53945D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
