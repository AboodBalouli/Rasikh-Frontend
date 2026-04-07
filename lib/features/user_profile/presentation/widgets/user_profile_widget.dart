import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/storage/secure_storage_token_provider.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/user.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class UserProfileWidget extends StatelessWidget {
  final User user;

  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Responsive.paddingAll(context),
      child: Column(
        children: [
          // Profile Header
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(context.wp(6)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: context.sp(60),
                      backgroundColor: TColors.primary.withValues(alpha: 0.1),
                      backgroundImage: user.profileImage.isNotEmpty
                          ? (user.profileImage.startsWith('http')
                                    ? NetworkImage(user.profileImage)
                                    : FileImage(File(user.profileImage)))
                                as ImageProvider
                          : null,
                      child: user.profileImage.isEmpty
                          ? Icon(
                              Icons.person,
                              size: context.sp(70),
                              color: TColors.primary,
                            )
                          : null,
                    ),
                    SizedBox(height: context.hp(2)),
                    // User Name
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: context.sp(26),
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.hp(1)),
                    // Verification Badge
                    if (user.isVerified)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.wp(3),
                          vertical: context.hp(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: TColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: TColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: TColors.primary,
                              size: context.sp(16),
                            ),
                            SizedBox(width: context.wp(1.5)),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: context.sp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: context.hp(3)),
          // Contact Information
          _buildSectionTitle(context, 'معلومات التواصل'),
          _buildInfoCard(
            context,
            Icons.email,
            'البريد الالكتروني',
            _display(user.email),
          ),
          _buildInfoCard(
            context,
            Icons.phone,
            'رقم الهاتف',
            _display(user.phone),
          ),
          SizedBox(height: context.hp(3)),
          // Address Information
          _buildSectionTitle(context, 'العنوان'),
          _buildInfoCard(
            context,
            Icons.location_on,
            'Address',
            _display(user.address),
          ),
          _buildInfoCard(
            context,
            Icons.location_city,
            'المدينة',
            _display(user.city),
          ),
          _buildInfoCard(
            context,
            Icons.public,
            'الدولة',
            _display(user.country),
          ),
          SizedBox(height: context.hp(3)),
          // Account Information
          _buildSectionTitle(context, 'معلومات الحساب'),
          _buildInfoCard(
            context,
            Icons.badge,
            'معرف المستخدم',
            _display(user.id),
          ),
          _buildInfoCard(
            context,
            Icons.calendar_today,
            'عضو منذ',
            _formatDate(user.createdAt),
          ),
          SizedBox(height: context.hp(3)),
          // Wallet Button
          CustomButton(
            text: '💰 المحفظة',
            onPressed: () => context.push('/wallet'),
            backgroundColor: TColors.primary.withValues(alpha: 0.85),
          ),
          SizedBox(height: context.hp(1.5)),
          // Edit Button
          CustomButton(
            text: 'تعديل الملف الشخصي',
            onPressed: () async {
              final userController = context.read<UserController>();
              await context.push(
                '/edit-profile',
                extra: EditProfilePageArgs(
                  user: user,
                  userController: userController,
                ),
              );
              if (context.mounted) {
                userController.fetchUserById(user.id);
              }
            },
            backgroundColor: TColors.primary,
          ),
          SizedBox(height: context.hp(1.5)),
          // Logout Button
          CustomButton(
            text: 'تسجيل الخروج',
            onPressed: () {
              const SecureStorageTokenProvider().clearToken();
              context.go('/');
            },
            backgroundColor: Colors.red[600],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.hp(2), top: context.hp(1.5)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
            color: TColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: EdgeInsets.only(bottom: context.hp(1.5)),
          padding: EdgeInsets.all(context.wp(4)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: TColors.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.primary.withValues(alpha: 0.2),
                      TColors.primary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: TColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(icon, color: TColors.primary, size: context.sp(20)),
              ),
              SizedBox(width: context.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: TColors.textPrimary.withValues(alpha: 0.6),
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w600,
                        color: TColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.year <= 1970) return '—';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _display(String value) {
    if (value.trim().isEmpty) return '—';
    return value;
  }
}
