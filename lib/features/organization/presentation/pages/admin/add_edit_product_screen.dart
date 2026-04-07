import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/features/organization/presentation/providers/add_edit_product_form_provider.dart';

/// Add/Edit Product Screen - Used for both adding new products and editing existing ones.
/// The mode is determined by whether a productId is provided.
class AddEditProductScreen extends ConsumerWidget {
  const AddEditProductScreen({super.key, this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(
      addEditProductFormControllerProvider(productId),
    );
    final controller = ref.read(
      addEditProductFormControllerProvider(productId).notifier,
    );
    final isEditMode = productId != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context, isEditMode),
        body: Stack(
          children: [
            // Content
            _buildContent(context, ref, formState, controller),
            // Floating Save Button
            _buildFloatingSaveButton(context, ref, formState, isEditMode),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isEditMode) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(color: Colors.white),
      leading: const CustomBackButton(),
      title: Text(
        isEditMode ? 'تعديل المنتج' : 'إضافة منتج جديد',
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
    AddEditProductFormState formState,
    AddEditProductFormController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
      child: Column(
        children: [
          // Product Image Card
          _buildImageSection(context, ref, formState, controller),
          const SizedBox(height: 24),
          // Product Name Card
          _buildNameSection(formState, controller),
          const SizedBox(height: 24),
          // Price Card
          _buildPriceSection(formState, controller),
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
    AddEditProductFormState formState,
    AddEditProductFormController controller,
  ) {
    final hasNewImage = formState.newImageBytes != null;
    final hasExistingImage = formState.existingImageUrl.isNotEmpty;
    final hasImage = hasNewImage || hasExistingImage;

    // Build full URL for existing image
    String fullImageUrl = formState.existingImageUrl;
    if (hasExistingImage && !formState.existingImageUrl.startsWith('http')) {
      fullImageUrl = '${AppConfig.apiBaseUrl}${formState.existingImageUrl}';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Row(
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 16,
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'صورة المنتج',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Image Preview (Square)
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasNewImage
                      ? Image.memory(
                          formState.newImageBytes!,
                          fit: BoxFit.cover,
                        )
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
              // Image Button
              CustomButton(
                onPressed: () => _handleSelectImage(ref, controller),
                text: hasImage ? 'تغيير الصورة' : 'اختيار صورة',
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
        ),
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

  Widget _buildNameSection(
    AddEditProductFormState formState,
    AddEditProductFormController controller,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Row(
                children: [
                  Icon(
                    Icons.label_outline,
                    size: 16,
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'اسم المنتج',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Name TextField
              _RiverpodTextField(
                initialValue: formState.name,
                onChanged: controller.setName,
                maxLength: 100,
                hintText: 'مثال: صابون طبيعي بزيت الزيتون',
                hasError: formState.nameError != null,
              ),
              if (formState.nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formState.nameError!,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(
    AddEditProductFormState formState,
    AddEditProductFormController controller,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'السعر',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price TextField
              _RiverpodTextField(
                initialValue: formState.price,
                onChanged: controller.setPrice,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                hintText: '0',
                hasError: formState.priceError != null,
              ),
              if (formState.priceError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formState.priceError!,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(
    AddEditProductFormState formState,
    AddEditProductFormController controller,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'وصف المنتج',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description TextField
              _RiverpodTextField(
                initialValue: formState.description,
                onChanged: controller.setDescription,
                maxLines: 4,
                hintText: 'اكتب وصفاً مختصراً عن المنتج...',
                hasError: formState.descriptionError != null,
              ),
              if (formState.descriptionError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
        ),
      ),
    );
  }

  Widget _buildFloatingSaveButton(
    BuildContext context,
    WidgetRef ref,
    AddEditProductFormState formState,
    bool isEditMode,
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
                  text: isEditMode ? 'حفظ التعديلات' : 'إضافة المنتج',
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

  Future<void> _handleSelectImage(
    WidgetRef ref,
    AddEditProductFormController controller,
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
    final controller = ref.read(
      addEditProductFormControllerProvider(productId).notifier,
    );
    final success = await controller.save();

    if (success && context.mounted) {
      _showSuccessSnackBar(
        context,
        productId != null ? 'تم تحديث المنتج بنجاح' : 'تم إضافة المنتج بنجاح',
      );
      context.pop();
    } else if (context.mounted) {
      final state = ref.read(addEditProductFormControllerProvider(productId));
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
        duration: const Duration(seconds: 2),
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
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// A reusable text field that works with Riverpod state instead of TextEditingController
class _RiverpodTextField extends StatefulWidget {
  const _RiverpodTextField({
    required this.initialValue,
    required this.onChanged,
    this.maxLength,
    this.maxLines = 1,
    this.hintText,
    this.keyboardType,
    this.hasError = false,
  });

  final String initialValue;
  final void Function(String) onChanged;
  final int? maxLength;
  final int maxLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool hasError;

  @override
  State<_RiverpodTextField> createState() => _RiverpodTextFieldState();
}

class _RiverpodTextFieldState extends State<_RiverpodTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_RiverpodTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the value changed externally (not from our own typing)
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
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF1A1A1A)),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.cairo(color: const Color(0xFF6B7280)),
        counterText: '',
        contentPadding: const EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: widget.hasError
                ? Colors.red
                : const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: widget.hasError
                ? Colors.red
                : const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: widget.hasError
                ? Colors.red
                : const Color.fromARGB(255, 83, 148, 93),
            width: 2,
          ),
        ),
      ),
    );
  }
}
