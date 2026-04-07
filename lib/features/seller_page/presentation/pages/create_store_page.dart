import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/features/shared/presentation/widgets/review_step_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/create_store_model.dart';
import '/core/constants/app_fonts.dart';
import '../providers/create_store_provider.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class CreateStorePage extends ConsumerStatefulWidget {
  const CreateStorePage({super.key});

  @override
  ConsumerState<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends ConsumerState<CreateStorePage> {
  int _currentStep = 0;
  final ImagePicker _picker = ImagePicker();

  // Form keys for validation
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  Uint8List? _logoBytes;
  Uint8List? _licenseBytes;
  List<Uint8List> _workSamplesBytes = [];
  bool _logoError = false;

  String? _selectedCategory;
  String? _selectedSubCategory;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> _mainCategories = ['أكل', 'حرف'];
  // String? _selectedGovernorate;
  // final _cityController = TextEditingController(text: '');

  Future<void> _pickMultiImages() async {
    if (_workSamplesBytes.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكنك اختيار 5 صور كحد أقصى')),
      );
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 70,
    );
    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        if (_workSamplesBytes.length < 5) {
          final bytes = await file.readAsBytes();
          setState(() => _workSamplesBytes.add(bytes));
        } else {
          break;
        }
      }
    }
  }

  Future<void> _pickSingleImage(bool isLogo) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isLogo)
          _logoBytes = bytes;
        else
          _licenseBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryColor = Color.fromARGB(255, 83, 148, 93);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: CustomBackButton()),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logobg.png',
          height: context.hp(10),
          fit: BoxFit.contain,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: primaryColor),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepTapped: (step) => null,
          controlsBuilder: (context, details) {
            // Hide controls on Step 3 (review step) since ReviewStepWidget has its own buttons
            if (_currentStep == 2) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(top: context.hp(2.5)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: context.hp(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 202, 224, 197),
                            Color.fromARGB(255, 83, 125, 93),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              162,
                              173,
                              171,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: details.onStepContinue,
                          borderRadius: BorderRadius.circular(30),
                          child: Center(
                            child: Text(
                              _currentStep == 2 ? "إرسال الطلب" : "التالي",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: context.sp(16),
                                fontFamily: AppFonts.parastoo,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    SizedBox(width: context.wp(4)),
                    Expanded(
                      child: Container(
                        height: context.hp(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromARGB(255, 83, 125, 93),
                            width: 2,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: details.onStepCancel,
                            borderRadius: BorderRadius.circular(30),
                            child: Center(
                              child: Text(
                                "رجوع",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 83, 125, 93),
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.sp(16),
                                  fontFamily: AppFonts.parastoo,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          onStepContinue: () {
            // الهوية
            if (_currentStep == 0) {
              if (_logoBytes == null) {
                HapticFeedback.lightImpact();
                setState(() => _logoError = true);
                return;
              }
              if (_logoError) setState(() => _logoError = false);
              if (!(_formKeyStep1.currentState?.validate() ?? false)) {
                HapticFeedback.lightImpact();
                return;
              }
            }

            //  التصنيف والبيانات
            if (_currentStep == 1) {
              if (_selectedCategory == null) {
                _showErrorMsg("يرجى اختيار نوع النشاط");
                HapticFeedback.lightImpact();
                return;
              }
              if (_selectedCategory == 'أكل' && _licenseBytes == null) {
                _showErrorMsg("الشهادة الصحية مطلوبة لنشاط الأكل");
                HapticFeedback.lightImpact();
                return;
              }
              if (_workSamplesBytes.length != 5) {
                _showErrorMsg("يجب رفع 5 صور بالضبط لأعمالك");
                HapticFeedback.lightImpact();
                return;
              }
            }

            if (_currentStep < 2) {
              setState(() => _currentStep += 1);
            } else {
              _handleFinalSubmit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep -= 1);
          },
          steps: _buildSteps(colorScheme, context),
        ),
      ),
    );
  }

  List<Step> _buildSteps(ColorScheme colorScheme, BuildContext context) {
    return [
      Step(
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        title: Text(
          "الهوية",
          style: TextStyle(
            fontFamily: AppFonts.parastoo,
            fontSize: context.sp(12),
          ),
        ),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildLogoPicker(colorScheme, context)),
              SizedBox(height: context.hp(3)),
              _buildTextField(
                "اسم المتجر",
                Icons.storefront,
                _nameController,
                context,
                maxLength: 15,
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                "وصف المتجر",
                Icons.description_outlined,
                _descController,
                context,
                maxLines: 3,
                maxLength: 500,
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                "الموقع",
                Icons.location_on,
                _locationController,
                context,
                maxLength: 150,
              ),
              SizedBox(height: context.hp(2)),
              _buildPhoneField(context),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        title: Text(
          "التصنيف",
          style: TextStyle(
            fontFamily: AppFonts.parastoo,
            fontSize: context.sp(12),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainCategoryDropdown(context),
            SizedBox(height: context.hp(2.5)),
            if (_selectedCategory == 'أكل') ...[
              _buildLicenseUploadArea(context),
              SizedBox(height: context.hp(2.5)),
            ],

            if (_selectedCategory != null) ...[
              _buildWorkSamplesArea(context),
              SizedBox(height: context.hp(2.5)),
            ],
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: Text(
          "الإنهاء",
          style: TextStyle(
            fontFamily: AppFonts.parastoo,
            fontSize: context.sp(12),
          ),
        ),
        content: ReviewStepWidget(
          onSubmit: () => _handleFinalSubmit(),
          onPrevious: () => setState(() => _currentStep--),
        ),
      ),
    ];
  }

  Widget _buildMainCategoryDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: "نوع النشاط ",
        labelStyle: TextStyle(fontSize: context.sp(14)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.wp(3),
          vertical: context.hp(1.5),
        ),
      ),
      items: _mainCategories
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(c, style: TextStyle(fontSize: context.sp(14))),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() {
        _selectedCategory = v;
        _selectedSubCategory = null;
      }),
    );
  }

  Widget _buildWorkSamplesArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.wp(4)),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _workSamplesBytes.length == 5
              ? Colors.blue.shade200
              : Colors.red.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "صور أعمالك (5 صور بالضبط) ",
                style: GoogleFonts.cairo(
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_workSamplesBytes.length}/5",
                style: TextStyle(
                  fontSize: context.sp(13),
                  color: _workSamplesBytes.length == 5
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: context.hp(1.5)),
          if (_workSamplesBytes.isNotEmpty)
            SizedBox(
              height: context.hp(12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _workSamplesBytes.length,
                itemBuilder: (context, index) => Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: context.wp(2)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _workSamplesBytes[index],
                          width: context.wp(20),
                          height: context.wp(20),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _workSamplesBytes.removeAt(index)),
                        child: CircleAvatar(
                          radius: context.sp(10),
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: context.sp(12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: context.hp(1.5)),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _workSamplesBytes.length >= 5
                  ? null
                  : _pickMultiImages,
              icon: Icon(Icons.add_photo_alternate, size: context.sp(20)),
              label: Text(
                "إضافة صور",
                style: TextStyle(fontSize: context.sp(14)),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoPicker(ColorScheme color, BuildContext context) {
    return GestureDetector(
      onTap: () => _pickSingleImage(true),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _logoError
                    ? Colors.red
                    : const Color.fromARGB(
                        255,
                        83,
                        148,
                        93,
                      ).withValues(alpha: 0.3),
                width: _logoError ? 2 : 1,
              ),
            ),
            child: CircleAvatar(
              radius: context.wp(15),
              backgroundColor: const Color.fromARGB(
                255,
                83,
                148,
                93,
              ).withValues(alpha: 0.1),
              backgroundImage: _logoBytes != null
                  ? MemoryImage(_logoBytes!)
                  : null,
              child: _logoBytes == null
                  ? Icon(
                      Icons.add_a_photo,
                      size: context.sp(40),
                      color: const Color.fromARGB(255, 83, 148, 93),
                    )
                  : null,
            ),
          ),
          SizedBox(height: context.hp(1)),
          Text(
            "صورة المتجر *",
            style: TextStyle(
              fontFamily: AppFonts.parastoo,
              fontSize: context.sp(12),
            ),
          ),
          if (_logoError)
            Padding(
              padding: EdgeInsets.only(top: context.hp(0.8)),
              child: Text(
                "هذا الحقل مطلوب",
                style: TextStyle(color: Colors.red, fontSize: context.sp(12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLicenseUploadArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.wp(4)),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _licenseBytes == null ? Colors.red.shade300 : Colors.amber,
        ),
      ),
      child: Column(
        children: [
          Text(
            "صورة الشهادة الصحية *",
            style: GoogleFonts.cairo(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.hp(1.5)),
          if (_licenseBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_licenseBytes!, height: context.hp(12)),
            ),
          SizedBox(height: context.hp(1.5)),
          ElevatedButton.icon(
            onPressed: () => _pickSingleImage(false),
            icon: Icon(Icons.upload_file, size: context.sp(20)),
            label: Text(
              _licenseBytes == null ? "رفع الشهادة" : "تغيير الملف",
              style: TextStyle(fontSize: context.sp(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
    BuildContext context, {
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.hp(2)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
        style: TextStyle(fontSize: context.sp(16)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: context.sp(14)),
          prefixIcon: Icon(icon, size: context.sp(24)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.wp(3),
            vertical: context.hp(1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: context.sp(12)),
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.hp(2)),
      child: TextFormField(
        controller: _phoneController,
        maxLength: 10,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          if (value.length != 10) {
            return 'رقم الهاتف يجب أن يكون 10 أرقام';
          }
          final jordanPhoneRegex = RegExp(r'^0(77|78|79)\d{7}$');
          if (!jordanPhoneRegex.hasMatch(value)) {
            return 'رقم هاتف أردني غير صالح (يجب أن يبدأ بـ 077 أو 078 أو 079)';
          }
          return null;
        },
        style: TextStyle(fontSize: context.sp(16)),
        decoration: InputDecoration(
          labelText: 'رقم للمتجر',
          labelStyle: TextStyle(fontSize: context.sp(14)),
          prefixIcon: Icon(Icons.phone, size: context.sp(24)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.wp(3),
            vertical: context.hp(1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: context.sp(12)),
        ),
      ),
    );
  }

  void _showErrorMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: GoogleFonts.cairo(fontSize: Responsive.sp(context, 14)),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleFinalSubmit() {
    final storeData = StoreModel(
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory!,
      subCategory: _selectedSubCategory,
      location: _locationController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      logo: _logoBytes!,
      healthLicense: _licenseBytes,
      workSamples: _workSamplesBytes,
    );

    // Navigate immediately to success page
    if (mounted) context.go('/store-success');

    // Submit in background (non-blocking)
    ref.read(createStoreProvider.notifier).submitStore(storeData);
  }

  void _showSuccessMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: GoogleFonts.cairo(fontSize: Responsive.sp(context, 14)),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
