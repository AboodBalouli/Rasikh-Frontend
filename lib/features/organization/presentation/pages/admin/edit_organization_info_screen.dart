import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/features/organization/presentation/providers/edit_org_info_form_provider.dart';

/// Edit Organization Info Screen - Allows editing phone, description, and cover image.
class EditOrganizationInfoScreen extends ConsumerWidget {
  const EditOrganizationInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(editOrgInfoFormControllerProvider);
    final controller = ref.read(editOrgInfoFormControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Background gradient
            Container(color: Colors.white),
            // Content
            _buildContent(context, ref, formState, controller),
            // Floating Save Button
            _buildFloatingSaveButton(context, ref, formState),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(color: Colors.white),
      leading: const CustomBackButton(),
      title: Text(
        'تعديل معلومات الجمعية',
        style: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 72,
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    EditOrgInfoFormState formState,
    EditOrgInfoFormController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        children: [
          // Image Section Card
          _buildImageSection(context, ref, formState, controller),
          const SizedBox(height: 24),
          // Phone Number Card
          _buildPhoneSection(formState, controller),
          const SizedBox(height: 24),
          // Description Card
          _buildDescriptionSection(formState, controller),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    WidgetRef ref,
    EditOrgInfoFormState formState,
    EditOrgInfoFormController controller,
  ) {
    final hasNewImage = formState.newImageBytes != null;
    final hasExistingImage = formState.coverImageUrl.isNotEmpty;

    // Build full URL for existing image
    String fullImageUrl = formState.coverImageUrl;
    if (hasExistingImage && !formState.coverImageUrl.startsWith('http')) {
      fullImageUrl = '${AppConfig.apiBaseUrl}${formState.coverImageUrl}';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                Icons.image_outlined,
                size: 16,
                color: const Color(0xFF1A1A1A),
              ),
              const SizedBox(width: 8),
              Text(
                'صورة الغلاف',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Image Preview
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasNewImage
                  ? Image.memory(formState.newImageBytes!, fit: BoxFit.cover)
                  : hasExistingImage
                  ? Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 12),
          // Change Image Button
          CustomButton(
            onPressed: () => _handleChangeImage(ref, controller),
            text: 'تغيير الصورة',
            isOutlined: true,
            height: 44,
            borderRadius: 12,
            textStyle: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 83, 148, 93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined, size: 48, color: Color(0xFF6B7280)),
          const SizedBox(height: 8),
          Text(
            'لم يتم اختيار صورة',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(
    EditOrgInfoFormState formState,
    EditOrgInfoFormController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: formState.phoneError != null
              ? Colors.red
              : Colors.black.withOpacity(0.1),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 16,
                color: const Color(0xFF1A1A1A),
              ),
              const SizedBox(width: 8),
              Text(
                'رقم الهاتف',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Phone TextField
          _PhoneTextField(
            initialValue: formState.phone,
            onChanged: controller.setPhone,
            hasError: formState.phoneError != null,
          ),
          if (formState.phoneError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 4),
              child: Text(
                formState.phoneError!,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
    EditOrgInfoFormState formState,
    EditOrgInfoFormController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: formState.descriptionError != null
              ? Colors.red
              : Colors.black.withOpacity(0.1),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 16,
                color: const Color(0xFF1A1A1A),
              ),
              const SizedBox(width: 8),
              Text(
                'وصف الجمعية',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description TextField
          _DescriptionTextField(
            initialValue: formState.description,
            onChanged: controller.setDescription,
            hasError: formState.descriptionError != null,
          ),
          if (formState.descriptionError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 4),
              child: Text(
                formState.descriptionError!,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Character Counter
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${formState.description.length} حرف',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingSaveButton(
    BuildContext context,
    WidgetRef ref,
    EditOrgInfoFormState formState,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0),
                ],
                stops: const [0, 0.7, 1],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  onPressed: () => _handleSave(context, ref),
                  text: 'حفظ التعديلات',
                  isLoading: formState.isSaving,
                  height: 56,
                  borderRadius: 16,
                  textStyle: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'الغاء',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangeImage(
    WidgetRef ref,
    EditOrgInfoFormController controller,
  ) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        controller.setImage(bytes);
      }
    } catch (e) {
      // Image selection failed
    }
  }

  Future<void> _handleSave(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();

    final controller = ref.read(editOrgInfoFormControllerProvider.notifier);
    final success = await controller.save();

    if (success && context.mounted) {
      _showSuccessSnackBar(context, 'تم حفظ التعديلات بنجاح');
      context.pop();
    } else if (context.mounted) {
      final state = ref.read(editOrgInfoFormControllerProvider);
      if (state.error != null) {
        _showErrorSnackBar(context, state.error!);
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(message, style: GoogleFonts.cairo()),
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(message, style: GoogleFonts.cairo()),
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Phone text field widget with proper controller management
class _PhoneTextField extends StatefulWidget {
  const _PhoneTextField({
    required this.initialValue,
    required this.onChanged,
    this.hasError = false,
  });

  final String initialValue;
  final void Function(String) onChanged;
  final bool hasError;

  @override
  State<_PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<_PhoneTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_PhoneTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.right,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        onChanged: widget.onChanged,
        style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText: '',
          hintStyle: GoogleFonts.cairo(color: const Color(0xFF6B7280)),
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.hasError
                  ? Colors.red
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.hasError
                  ? Colors.red
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.hasError ? Colors.red : const Color(0xFF030213),
            ),
          ),
        ),
      ),
    );
  }
}

/// Description text field widget with proper controller management
class _DescriptionTextField extends StatefulWidget {
  const _DescriptionTextField({
    required this.initialValue,
    required this.onChanged,
    this.hasError = false,
  });

  final String initialValue;
  final void Function(String) onChanged;
  final bool hasError;

  @override
  State<_DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<_DescriptionTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_DescriptionTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 6,
      inputFormatters: [LengthLimitingTextInputFormatter(500)],
      style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF1A1A1A)),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'اكتب نبذة عن الجمعية وأهدافها...',
        hintStyle: GoogleFonts.cairo(color: const Color(0xFF6B7280)),
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : Colors.black.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : Colors.black.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : const Color(0xFF030213),
          ),
        ),
      ),
    );
  }
}
