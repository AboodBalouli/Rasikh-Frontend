import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class EmptyCartPage extends ConsumerStatefulWidget {
  const EmptyCartPage({super.key});

  @override
  ConsumerState<EmptyCartPage> createState() => _EmptyCartPageState();
}

class _EmptyCartPageState extends ConsumerState<EmptyCartPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.cart,
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A7C59),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: Responsive.paddingAll(context),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(context.wp(8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A7C59).withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: context.sp(60),
                        color: const Color(0xFF4A7C59).withOpacity(0.7),
                      ),
                    ),
                  ),
                  SizedBox(height: context.hp(5)),
                  Text(
                    AppStrings.emptyCart,
                    style: TextStyle(
                      fontFamily: AppFonts.parastoo,
                      fontSize: context.sp(26),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: context.hp(1)),
                  Text(
                    AppStrings.letsFillCart,
                    style: TextStyle(
                      fontFamily: AppFonts.parastoo,
                      fontSize: context.sp(15),
                      color: const Color(0xFF636E72),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: context.hp(5)),
                  _buildShopButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF5A9367), Color(0xFF4A7C59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A7C59).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final router = GoRouter.of(context);
              if (router.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.wp(10),
                vertical: context.hp(2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: context.sp(20),
                  ),
                  SizedBox(width: context.wp(2)),
                  Text(
                    AppStrings.shopNow,
                    style: TextStyle(
                      fontFamily: AppFonts.parastoo,
                      fontSize: context.sp(17),
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
