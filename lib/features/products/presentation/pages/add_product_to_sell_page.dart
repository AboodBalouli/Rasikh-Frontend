import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/app/dependency_injection/products_dependency_injection.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  AddProductPageState createState() => AddProductPageState();
}

class AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  List<Uint8List> _images = [];
  bool _isSubmitting = false;

  final TextEditingController _mainPriceController = TextEditingController();
  final List<String> _selectedTags = [];
  final picker = ImagePicker();

  List<String> _availableTags = [];
  bool _isLoadingTags = true;
  String? _tagsError;

  bool _hasSellerCategory = false;
  String? _sellerCategoryError;

  static const Color primaryGreen = Color.fromARGB(255, 83, 148, 93);
  static const int maxImages = 5;

  @override
  void initState() {
    super.initState();
    _loadShopTags();
  }

  Future<void> _loadShopTags() async {
    try {
      final getMyProfile = ref.read(getMyProfileProvider);
      final profile = await getMyProfile();

      final hasCategory = profile.sellerCategory != null;
      final tags = profile.store?.tags ?? [];

      setState(() {
        _hasSellerCategory = hasCategory;
        _sellerCategoryError = hasCategory
            ? null
            : 'يجب تعيين فئة البائع قبل إضافة المنتجات';
        _availableTags = tags;
        _isLoadingTags = false;
      });
    } catch (e) {
      setState(() {
        _tagsError = 'فشل في تحميل البيانات';
        _isLoadingTags = false;
      });
    }
  }

  @override
  void dispose() {
    _mainPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_images.length >= maxImages) {
      _showSnackbar('يمكنك إضافة $maxImages صور كحد أقصى');
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _images.add(bytes));
    }
  }

  Future<void> _pickMultipleImages() async {
    if (_images.length >= maxImages) {
      _showSnackbar('يمكنك إضافة $maxImages صور كحد أقصى');
      return;
    }

    final remaining = maxImages - _images.length;
    final pickedFiles = await picker.pickMultiImage();
    
    if (pickedFiles.isNotEmpty) {
      final filesToAdd = pickedFiles.take(remaining).toList();
      for (final file in filesToAdd) {
        final bytes = await file.readAsBytes();
        setState(() => _images.add(bytes));
      }
      
      if (pickedFiles.length > remaining) {
        _showSnackbar('تم إضافة $remaining صور فقط (الحد الأقصى $maxImages)');
      }
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else if (_selectedTags.length < 3) {
        _selectedTags.add(tag);
      } else {
        _showSnackbar('يمكنك اختيار 3 تاقات كحد أقصى');
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_images.isEmpty) {
        _showSnackbar('يرجى اختيار صورة واحدة على الأقل');
        return;
      }

      if (_selectedTags.isEmpty) {
        _showSnackbar('يرجى اختيار تاق واحد على الأقل');
        return;
      }

      final double price = double.tryParse(_mainPriceController.text) ?? 0.0;

      setState(() => _isSubmitting = true);

      try {
        final createProduct = ref.read(createProductWithImagesProvider);

        await createProduct(
          name: _name,
          description: _description,
          price: price,
          tags: _selectedTags,
          images: _images,
        );

        _showSnackbar('تم إضافة المنتج بنجاح!');

        if (mounted) {
          context.pop(true);
        }
      } catch (e) {
        _showSnackbar('فشل في إضافة المنتج: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryGreen, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(
          'إضافة منتج جديد',
          style: GoogleFonts.cairo(
            fontSize: context.sp(20),
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isLoadingTags && _sellerCategoryError != null)
                _buildWarningCard(context),

              // Images Section
              _buildSectionTitle("صور المنتج", Icons.photo_library_outlined),
              const SizedBox(height: 8),
              Text(
                'يمكنك إضافة حتى $maxImages صور (${_images.length}/$maxImages)',
                style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              _buildImagesSection(),
              const SizedBox(height: 28),

              // Product Info Section
              _buildSectionTitle("معلومات المنتج", Icons.info_outline_rounded),
              const SizedBox(height: 16),
              _buildModernTextField(
                label: "اسم المنتج",
                hint: "أدخل اسم المنتج",
                icon: Icons.shopping_bag_outlined,
                onSave: (val) => _name = val!,
              ),
              const SizedBox(height: 16),
              _buildPriceField(),
              const SizedBox(height: 16),
              _buildModernTextField(
                label: "وصف المنتج",
                hint: "يحتاج المنتج من 3 إلى 4 أيام للتجهيز",
                icon: Icons.description_outlined,
                onSave: (val) => _description = val!,
                maxLines: 4,
              ),
              const SizedBox(height: 28),

              // Tags Section
              _buildSectionTitle("الكلمات المفتاحية", Icons.tag_rounded),
              const SizedBox(height: 12),
              _buildTagsSection(context),
              const SizedBox(height: 40),

              // Submit Button
              _buildSubmitButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryGreen, size: 20),
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

  Widget _buildWarningCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            _sellerCategoryError!,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Images Grid
          if (_images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: index == 0
                            ? Border.all(color: primaryGreen, width: 2)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    // Main image badge
                    if (index == 0)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryGreen,
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
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          
          if (_images.isNotEmpty) const SizedBox(height: 16),

          // Add more images button
          if (_images.length < maxImages)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryGreen.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.add_a_photo_outlined, color: primaryGreen, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            'صورة واحدة',
                            style: GoogleFonts.cairo(color: primaryGreen, fontSize: 12),
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
                          colors: [primaryGreen, primaryGreen.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            'صور متعددة',
                            style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          if (_images.isEmpty)
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

  Widget _buildModernTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String?) onSave,
    int maxLines = 1,
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
        maxLines: maxLines,
        style: GoogleFonts.cairo(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.cairo(color: primaryGreen, fontWeight: FontWeight.w600),
          hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryGreen, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        validator: (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
        onSaved: onSave,
      ),
    );
  }

  Widget _buildPriceField() {
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
        controller: _mainPriceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.cairo(fontSize: 15),
        decoration: InputDecoration(
          labelText: 'السعر',
          hintText: '0.00',
          labelStyle: GoogleFonts.cairo(color: primaryGreen, fontWeight: FontWeight.w600),
          hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
          suffixText: 'JD',
          suffixStyle: GoogleFonts.cairo(color: primaryGreen, fontWeight: FontWeight.bold),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.payments_outlined, color: primaryGreen, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          final price = double.tryParse(value);
          if (price == null) {
            return 'يرجى إدخال رقم صحيح';
          }
          if (price <= 0) {
            return 'السعر يجب أن يكون أكبر من صفر';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTagsSection(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoadingTags)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: primaryGreen),
              ),
            )
          else if (_tagsError != null)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 32),
                  const SizedBox(height: 12),
                  Text(_tagsError!, style: GoogleFonts.cairo(color: Colors.red)),
                  TextButton.icon(
                    onPressed: _loadShopTags,
                    icon: const Icon(Icons.refresh, color: primaryGreen),
                    label: Text('إعادة المحاولة', style: GoogleFonts.cairo(color: primaryGreen)),
                  ),
                ],
              ),
            )
          else if (_availableTags.isEmpty)
            Center(
              child: Text(
                'لا توجد تاقات في متجرك',
                style: GoogleFonts.cairo(color: Colors.grey[600]),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر التاقات (${_selectedTags.length}/3)',
                  style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () => _toggleTag(tag),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(colors: [primaryGreen, primaryGreen.withOpacity(0.8)])
                              : null,
                          color: isSelected ? null : primaryGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? primaryGreen : primaryGreen.withOpacity(0.3),
                            width: isSelected ? 0 : 1,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final bool canSubmit = !_isSubmitting && _hasSellerCategory;

    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: canSubmit
            ? LinearGradient(colors: [primaryGreen, primaryGreen.withOpacity(0.85)])
            : null,
        color: canSubmit ? null : Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
        boxShadow: canSubmit
            ? [BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6))]
            : null,
      ),
      child: ElevatedButton(
        onPressed: canSubmit ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.publish_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "نشر المنتج الآن",
                    style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
