import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/organization/presentation/providers/admin_providers.dart';
import '/core/entities/product_card_model.dart';
import '/features/products/presentation/providers/providers.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final ProductCardModel product;

  const EditProductPage({super.key, required this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagController;
  List<String> _tags = [];

  // Error state for real-time validation
  String? _titleError;
  String? _priceError;
  String? _descriptionError;
  String? _tagsError;

  bool _isSubmitting = false;

  // Multiple images support
  List<Uint8List> _newImages = [];
  List<String> _existingImagePaths = [];

  static const Color primaryGreen = Color.fromARGB(255, 83, 148, 93);
  static const int maxImages = 5;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(text: widget.product.price);
    _descriptionController = TextEditingController(
      text: widget.product.description ?? "",
    );
    _tags = List<String>.from(widget.product.tags ?? []);
    _tagController = TextEditingController();

    // Load existing images from imagePaths (multi-image support)
    final productImages = widget.product.imagePaths ?? [];
    if (productImages.isNotEmpty) {
      _existingImagePaths = List<String>.from(productImages);
    } else if (widget.product.imagePath != null &&
        widget.product.imagePath!.isNotEmpty) {
      // Fallback to single imagePath for backwards compatibility
      _existingImagePaths = [widget.product.imagePath!];
    }
    if (widget.product.imageFile != null &&
        widget.product.imageFile is Uint8List) {
      _newImages = [widget.product.imageFile as Uint8List];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  int get _totalImagesCount => _existingImagePaths.length + _newImages.length;

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    if (_totalImagesCount >= maxImages) {
      _showSnackbar('يمكنك إضافة $maxImages صور كحد أقصى');
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _newImages.add(bytes));
    }
  }

  Future<void> _pickMultipleImages() async {
    if (_totalImagesCount >= maxImages) {
      _showSnackbar('يمكنك إضافة $maxImages صور كحد أقصى');
      return;
    }

    final remaining = maxImages - _totalImagesCount;
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final filesToAdd = pickedFiles.take(remaining).toList();
      for (final file in filesToAdd) {
        final bytes = await file.readAsBytes();
        setState(() => _newImages.add(bytes));
      }

      if (pickedFiles.length > remaining) {
        _showSnackbar('تم إضافة $remaining صور فقط (الحد الأقصى $maxImages)');
      }
    }
  }

  void _removeExistingImage(int index) {
    setState(() => _existingImagePaths.removeAt(index));
  }

  void _removeNewImage(int index) {
    setState(() => _newImages.removeAt(index));
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);
    final bool isCharity = userType == UserType.charity;
    final Color dynamicPrimary = isCharity ? Colors.green[700]! : primaryGreen;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "تعديل المنتج",
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dynamicPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: dynamicPrimary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              _buildSectionTitle(
                "صور المنتج",
                Icons.photo_library_outlined,
                dynamicPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                'يمكنك إضافة حتى $maxImages صور ($_totalImagesCount/$maxImages)',
                style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              _buildImagesSection(dynamicPrimary),
              const SizedBox(height: 28),

              // Product Info Section
              _buildSectionTitle(
                "معلومات المنتج",
                Icons.info_outline_rounded,
                dynamicPrimary,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                controller: _titleController,
                label: "اسم المنتج",
                hint: "أدخل اسم المنتج",
                icon: Icons.shopping_bag_outlined,
                primary: dynamicPrimary,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                controller: _priceController,
                label: "السعر (JD)",
                hint: "0.00",
                icon: Icons.payments_outlined,
                primary: dynamicPrimary,
                isPrice: true,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                controller: _descriptionController,
                label: "وصف المنتج",
                hint: "أضف وصفاً تفصيلياً للمنتج...",
                icon: Icons.description_outlined,
                primary: dynamicPrimary,
                maxLines: 4,
              ),
              const SizedBox(height: 28),

              // Tags Section
              _buildSectionTitle(
                "الكلمات المفتاحية",
                Icons.tag_rounded,
                dynamicPrimary,
              ),
              const SizedBox(height: 12),
              _buildTagsSection(dynamicPrimary),
              const SizedBox(height: 40),

              // Save Button
              _buildSaveButton(dynamicPrimary),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color primary) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primary, size: 20),
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

  Widget _buildImagesSection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Images Grid
          if (_totalImagesCount > 0)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _totalImagesCount,
              itemBuilder: (context, index) {
                final isExistingImage = index < _existingImagePaths.length;
                final isMainImage = index == 0;

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isMainImage
                            ? Border.all(color: primary, width: 2)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: isExistingImage
                            ? _buildNetworkImage(
                                _existingImagePaths[index],
                                primary,
                              )
                            : Image.memory(
                                _newImages[index - _existingImagePaths.length],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
                    ),
                    // Main image badge
                    if (isMainImage)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'رئيسية',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Delete button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          if (isExistingImage) {
                            _removeExistingImage(index);
                          } else {
                            _removeNewImage(index - _existingImagePaths.length);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          if (_totalImagesCount > 0) const SizedBox(height: 16),

          // Add more images buttons
          if (_totalImagesCount < maxImages)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: primary,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'صورة واحدة',
                            style: GoogleFonts.cairo(
                              color: primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickMultipleImages,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, primary.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'صور متعددة',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          if (_totalImagesCount == 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'الصورة الأولى ستكون الصورة الرئيسية للمنتج',
                style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey[500]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(String path, Color primary) {
    final url = _resolveImageUrl(path);
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Center(
        child: Icon(Icons.broken_image, color: primary.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color primary,
    int maxLines = 1,
    bool isNumber = false,
    bool isPrice = false,
  }) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber || isPrice
            ? TextInputType.number
            : TextInputType.text,
        style: GoogleFonts.cairo(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.cairo(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primary, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          if (isPrice) {
            final price = double.tryParse(value);
            if (price == null) {
              return 'يرجى إدخال رقم صحيح';
            }
            if (price <= 0) {
              return 'السعر يجب أن يكون أكبر من صفر';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTagsSection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tagController,
                  style: GoogleFonts.cairo(),
                  decoration: InputDecoration(
                    hintText: "أضف كلمة مفتاحية...",
                    hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => _addTag(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primary.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  onPressed: _addTag,
                ),
              ),
            ],
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _tags
                  .map((tag) => _buildModernTag(tag, primary))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernTag(String tag, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tag_rounded, size: 14, color: primary),
          const SizedBox(width: 6),
          Text(
            tag,
            style: GoogleFonts.cairo(
              color: primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => _tags.remove(tag)),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, size: 14, color: primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(Color primary) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primary.withOpacity(0.85)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : () async {
                // Validate form fields
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                // Check for required tags
                if (_tags.isEmpty) {
                  _showSnackbar('يرجى إضافة تاق واحد على الأقل');
                  return;
                }

                // Check for at least one image
                if (_totalImagesCount == 0) {
                  _showSnackbar('يرجى إضافة صورة واحدة على الأقل');
                  return;
                }

                setState(() => _isSubmitting = true);

                try {
                  final updateProduct = ref.read(updateProductUseCaseProvider);
                  final productId = int.tryParse(widget.product.id ?? '') ?? 0;

                  if (productId > 0) {
                    // Call backend API to update the product
                    await updateProduct.call(
                      productId: productId,
                      name: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      price:
                          double.tryParse(_priceController.text.trim()) ?? 0.0,
                      tags: _tags,
                    );

                    // Upload new images if any
                    if (_newImages.isNotEmpty) {
                      final uploadImages = ref.read(
                        uploadProductImagesUseCaseProvider,
                      );
                      await uploadImages.call(
                        productId: productId,
                        imageBytes: _newImages,
                      );
                    }
                  }

                  if (mounted) {
                    _showSnackbar('تم حفظ التغييرات بنجاح');
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (mounted) {
                    _showSnackbar('فشل في حفظ التغييرات: ${e.toString()}');
                    setState(() => _isSubmitting = false);
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              "حفظ التغييرات",
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '${AppConfig.apiBaseUrl}$path';
    return '${AppConfig.apiBaseUrl}/$path';
  }
}
