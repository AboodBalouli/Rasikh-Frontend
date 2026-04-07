import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '/features/products/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';

class AccountInfoPage extends ConsumerStatefulWidget {
  const AccountInfoPage({super.key});

  @override
  ConsumerState<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends ConsumerState<AccountInfoPage> {
  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    Future.microtask(() => ref.read(storeSettingsControllerProvider).load());
  }

  Future<void> _onRefresh() async {
    await ref.read(storeSettingsControllerProvider).load();
  }

  String? _toAbsoluteImageUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.trim().isEmpty) return null;
    final trimmed = pathOrUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  ImageProvider _getProfileImage() {
    final controller = ref.read(storeSettingsControllerProvider);
    final profile = controller.profile;

    final url = _toAbsoluteImageUrl(profile?.profilePicturePath);
    if (url != null) return NetworkImage(url);

    return const AssetImage('assets/images/photo5.png');
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final skipped = ref.read(storeSettingsControllerProvider).isSaving;
    if (skipped) return;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      await ref.read(storeSettingsControllerProvider).uploadProfilePicture(
            bytes: bytes,
            filename: pickedFile.name,
          );
      if (mounted) {
        final error = ref.read(storeSettingsControllerProvider).error;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل تحميل الصورة: $error', style: GoogleFonts.cairo()),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تحديث الصورة الشخصية بنجاح', style: GoogleFonts.cairo()),
              backgroundColor: const Color.fromARGB(255, 83, 148, 93),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(storeSettingsControllerProvider);
    final userType = ref.watch(userTypeProvider);
    final bool isCharity = userType == UserType.charity;

    final profile = controller.profile;

    // Build display name from profile
    final String displayName;
    if (profile != null) {
      final firstName = profile.firstName;
      final lastName = profile.lastName;
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        displayName = '$firstName $lastName'.trim();
      } else {
        displayName =
            profile.store?.storeName ??
            (isCharity ? 'مسؤول الجمعية' : 'اسم البائع');
      }
    } else {
      displayName = isCharity ? 'مسؤول الجمعية' : 'اسم البائع';
    }

    // Get email from profile
    final String displayEmail = profile?.email ?? '';

    final Color primaryGreen = const Color.fromARGB(255, 83, 148, 93);
    final Color primaryColor = isCharity ? Colors.green[700]! : primaryGreen;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: primaryColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          isCharity ? "حساب الجمعية" : "معلومات الحساب",
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- Profile Section ----------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickAndUploadImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.2),
                                        width: 2),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: _getProfileImage(),
                                  ),
                                ),
                              ),
                              if (controller.isSaving)
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickAndUploadImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            displayName,
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          if (displayEmail.isNotEmpty)
                            Text(
                              displayEmail,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------- Settings Sections ----------------
                    _buildSectionTitle(
                      isCharity ? "إعدادات الجمعية" : "إعدادات المتجر",
                      Icons.settings_outlined,
                      primaryColor,
                    ),
                    const SizedBox(height: 16),

                    _buildSettingItem(
                      icon: Icons.payments_outlined,
                      title: "طرق الدفع",
                      onTap: () => context.push('/payment-methods'),
                      color: primaryColor,
                    ),

                    if (!isCharity) ...[
                      _buildSettingItem(
                        icon: Icons.analytics_outlined,
                        title: "إحصائيات المتجر",
                        onTap: () => context.push('/store-dashboard'),
                        color: primaryColor,
                      ),
                      _buildSettingItem(
                        icon: Icons.storefront_outlined,
                        title: "إعدادات المتجر العامة",
                        onTap: () => context.push('/seller-settings'),
                        color: primaryColor,
                      ),
                    ],

                    if (isCharity) ...[
                      _buildSettingItem(
                        icon: Icons.analytics_outlined,
                        title: "معلومات الجمعية ",
                        onTap: () => context.push('/personal-info-edit'),
                        color: primaryColor,
                      ),
                      _buildSettingItem(
                        icon: Icons.analytics_outlined,
                        title: "إحصائيات الجمعية ",
                        onTap: () => context.push('/store-dashboard'),
                        color: primaryColor,
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color primaryColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
