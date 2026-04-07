import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';

/// Args for the create custom order page.
@immutable
class CreateCustomOrderPageArgs {
  final String sellerProfileId;
  final String? sellerStoreName;

  const CreateCustomOrderPageArgs({
    required this.sellerProfileId,
    this.sellerStoreName,
  });
}

/// Page for creating a custom order request to a specific seller.
class CreateCustomOrderPage extends ConsumerStatefulWidget {
  final String sellerProfileId;
  final String? sellerStoreName;

  const CreateCustomOrderPage({
    super.key,
    required this.sellerProfileId,
    this.sellerStoreName,
  });

  @override
  ConsumerState<CreateCustomOrderPage> createState() =>
      _CreateCustomOrderPageState();
}

class _CreateCustomOrderPageState extends ConsumerState<CreateCustomOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _whatsappController = TextEditingController();

  // Use XFile instead of File for cross-platform support (including web)
  List<XFile> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _pickedImages = pickedFiles;
        });
      }
    } catch (e) {
      // Fallback for single image if multi-image not supported
      final XFile? singleImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (singleImage != null) {
        setState(() {
          _pickedImages = [singleImage];
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final controller = ref.read(customOrdersControllerProvider);

    // Build whatsapp URL from phone
    final phone = _phoneController.text.replaceAll(RegExp(r'^0'), '962');
    final whatsappUrl = _whatsappController.text.isNotEmpty
        ? _whatsappController.text
        : 'https://wa.me/$phone';

    // Note: On web, file paths won't work for upload.
    // For now, we pass paths for mobile. Web upload needs different handling.
    final order = await controller.create(
      sellerProfileId: widget.sellerProfileId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      whatsappUrl: whatsappUrl,
      imagePaths: kIsWeb ? [] : _pickedImages.map((f) => f.path).toList(),
    );

    setState(() => _isSubmitting = false);

    if (order != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال طلبك بنجاح', style: GoogleFonts.cairo()),
          backgroundColor: const Color(0xFF53945D),
        ),
      );
      context.pop(true);
    } else if (controller.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error!, style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'طلب خاص',
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
              // Seller info banner
              if (widget.sellerStoreName != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.wp(3)),
                  margin: EdgeInsets.only(bottom: context.hp(2)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF53945D).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storefront,
                        color: const Color(0xFF53945D),
                        size: context.sp(20),
                      ),
                      SizedBox(width: context.wp(2)),
                      Expanded(
                        child: Text(
                          'إرسال طلب إلى: ${widget.sellerStoreName}',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF53945D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Title field
              _buildLabel('عنوان الطلب'),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('مثال: كيكة عيد ميلاد مخصصة'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
              ),

              SizedBox(height: context.hp(2.5)),

              // Description field
              _buildLabel('وصف الطلب'),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration('صف طلبك بالتفصيل...'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
              ),

              SizedBox(height: context.hp(2.5)),

              // Images
              _buildLabel('صور (اختياري)'),
              SizedBox(height: context.hp(1)),
              _buildImagePicker(),

              SizedBox(height: context.hp(2.5)),

              // Phone field
              _buildLabel('رقم الهاتف'),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: _inputDecoration('07XXXXXXXX'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
                  if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(value)) {
                    return 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079';
                  }
                  return null;
                },
              ),

              SizedBox(height: context.hp(2.5)),

              // Location field
              _buildLabel('الموقع'),
              SizedBox(height: context.hp(1)),
              TextFormField(
                controller: _locationController,
                decoration: _inputDecoration('مثال: عمان - الجبيهة'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
              ),

              SizedBox(height: context.hp(4)),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: context.hp(7),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53945D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'إرسال الطلب',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: context.hp(2)),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'إلغاء',
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(14),
                      color: Colors.grey[600],
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: context.sp(15),
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3748),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF53945D), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(1.5),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_pickedImages.isNotEmpty) ...[
          SizedBox(
            height: context.hp(12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: context.wp(25),
                      margin: EdgeInsets.only(right: context.wp(2)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildImageWidget(_pickedImages[index]),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: context.wp(2) + 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: context.sp(14),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: context.hp(1)),
        ],
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: context.hp(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: context.sp(28),
                  color: Colors.grey[500],
                ),
                SizedBox(height: context.hp(0.5)),
                Text(
                  'اضغط لإضافة صور',
                  style: GoogleFonts.cairo(
                    fontSize: context.sp(13),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build image widget that works on both web and mobile
  Widget _buildImageWidget(XFile xFile) {
    if (kIsWeb) {
      // On web, use FutureBuilder to read bytes and display
      return FutureBuilder<Uint8List>(
        future: xFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else {
      // On mobile, use Image.network with file path
      return Image.network(
        xFile.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to reading as bytes if network fails
          return FutureBuilder<Uint8List>(
            future: xFile.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              }
              return const Center(child: Icon(Icons.image));
            },
          );
        },
      );
    }
  }
}
