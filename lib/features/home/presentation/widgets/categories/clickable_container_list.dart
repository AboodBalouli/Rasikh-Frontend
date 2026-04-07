/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/clickable_container.dart';
import 'package:go_router/go_router.dart';

class ClickableContainerList extends StatefulWidget {
  const ClickableContainerList({super.key});

  @override
  State<StatefulWidget> createState() => _ClickableContainerListState();
}

class _ClickableContainerListState extends State<ClickableContainerList> {
  @override
  Widget build(BuildContext context) {
    final categories = <ClickableContainer>[
      const ClickableContainer(
        T: Icons.category,
        name: 'الفئات',
        bgColor: Color.fromARGB(175, 122, 67, 185),
      ),
      ClickableContainer(
        T: Icons.discount_outlined,
        name: 'الطلبات العامة',
        bgColor: const Color.fromARGB(255, 74, 111, 140),
        onTap: () {
          // Navigate to orders page
          context.push('/public-orders');
        },
      ),
      ClickableContainer(
        T: Icons.auto_awesome,
        name: 'تحدث إلى الذكاء الاصطناعي',
        bgColor: const Color.fromARGB(175, 185, 67, 122),
        onTap: () {
          // Navigate to AI chat page
          context.push('/ai-chat');
        },
      ),
      ClickableContainer(
        T: Icons.archive,
        name: 'الطلبات السابقة',
        bgColor: const Color.fromARGB(175, 67, 185, 122),
        onTap: () {
          context.push('/past-orders');
        },
      ),
      ClickableContainer(
        T: Icons.help_outline,
        name: 'الاسئلة الشائعة',
        bgColor: const Color.fromARGB(255, 140, 111, 74),
        onTap: () {
          // Navigate to FAQ page
          context.push('/faq');
        },
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [...categories]),
    );
  }
}
*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/categories/clickable_container.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:go_router/go_router.dart';

class ClickableContainerList extends StatefulWidget {
  const ClickableContainerList({super.key});

  @override
  State<StatefulWidget> createState() => _ClickableContainerListState();
}

class _ClickableContainerListState extends State<ClickableContainerList> {
  void _showGuestLoginDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: IntrinsicWidth(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 44,
                            color: TColors.primary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'يجب ان يكون لديك حساب',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: TColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'تسجيل دخول',
                                  onPressed: () {
                                    dialogContext.pop();
                                    context.push('/login');
                                  },
                                  backgroundColor: TColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  text: 'انشاء حساب',
                                  onPressed: () {
                                    dialogContext.pop();
                                    context.push('/register');
                                  },
                                  backgroundColor: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => dialogContext.pop(),
                            child: const Text(
                              'الغاء',
                              style: TextStyle(
                                fontSize: 14,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAiTap(BuildContext context) async {
    final authLocalDataSource = AuthLocalDataSource();
    final token = await authLocalDataSource.getToken();
    if (token == null || token.isEmpty) {
      if (!context.mounted) return;
      _showGuestLoginDialog(context);
    } else {
      context.push('/ai-chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = [
      {
        'icon': Icons.discount_outlined,
        'name': 'الطلبات العامة',
        'color': const Color.fromARGB(255, 180, 200, 220),
        'route': '/public-orders',
        'requiresAuth': false,
      },
      {
        'icon': Icons.auto_awesome,
        'name': 'الذكاء الاصطناعي',
        'color': const Color.fromARGB(255, 230, 180, 200),
        'route': '/ai-chat',
        'requiresAuth': true,
      },
      {
        'icon': Icons.archive_outlined,
        'name': 'الطلبات السابقة',
        'color': const Color.fromARGB(255, 180, 220, 200),
        'route': '/past-orders',
        'requiresAuth': false,
      },
      {
        'icon': Icons.help_outline,
        'name': 'الأسئلة الشائعة',
        'color': const Color.fromARGB(255, 220, 200, 180),
        'route': '/faq',
        'requiresAuth': false,
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
        itemCount: categoryData.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: Sizes.spacingBetweenItems - 16),
        itemBuilder: (context, index) {
          final item = categoryData[index];
          return ClickableContainer(
            T: item['icon'] as IconData,
            name: item['name'] as String,
            bgColor: item['color'] as Color,
            onTap: () {
              if (item['requiresAuth'] == true) {
                _handleAiTap(context);
              } else {
                context.push(item['route'] as String);
              }
            },
          );
        },
      ),
    );
  }
}
