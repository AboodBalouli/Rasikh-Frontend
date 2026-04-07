import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/seller_page/presentation/seller_notifier.dart';
import 'package:flutter_application_1/features/settings/presentation/user/theme_provider.dart';
import 'package:flutter_application_1/features/settings/presentation/user/user_notifier.dart'
    as user_logic;

class SellerSettingsPage extends ConsumerStatefulWidget {
  const SellerSettingsPage({super.key});

  @override
  ConsumerState<SellerSettingsPage> createState() => _SellerSettingsPageState();
}

class _SellerSettingsPageState extends ConsumerState<SellerSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'ikram');
  final _bioController = TextEditingController(text: 'مرحباً بكم في متجري!');
  String? _selectedGovernorate;
  final _cityController = TextEditingController(text: '');
  final List<String> _jordanGovernorates = [
    'عمان',
    'إربد',
    'الزرقاء',
    'البلقاء',
    'مأدبا',
    'الكرك',
    'الطفيلة',
    'معان',
    'العقبة',
    'جرش',
    'عجلون',
  ];
  final _phoneController = TextEditingController(text: '07XXXXXXXX');
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 22, minute: 0);
  File? _pickedImage;

  Color? _tempSelectedColor;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      setState(() {
        _tempSelectedColor = ref.read(themeColorProvider);
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();

      ref.read(user_logic.userImageProvider.notifier).setImage(imageBytes);
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpening ? _openingTime : _closingTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
  }

  void _saveAllSettings() {
    if (_formKey.currentState!.validate()) {
      final sellerNotifier = ref.read(sellerProvider.notifier);
      final location =
          '${_selectedGovernorate ?? ''} / ${_cityController.text}';
      final workingHours =
          '${_openingTime.format(context)} - ${_closingTime.format(context)}';

      sellerNotifier.updateData(
        newStoreName: _nameController.text,
        newDescription: _bioController.text,
        phone: _phoneController.text,
        newStoreLocation: location,
        newAvatarFilePath: _pickedImage?.path,
        workingHours: workingHours,
      );
      if (_tempSelectedColor != null) {
        ref.read(themeColorProvider.notifier).setColor(_tempSelectedColor!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ جميع التغييرات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pickedImageBytes = ref.watch(user_logic.userImageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الإعدادات العامة",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(Icons.store_mall_directory, "معلومات المتجر"),
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: pickedImageBytes != null
                          ? MemoryImage(pickedImageBytes)
                          : (_pickedImage != null
                                ? FileImage(_pickedImage!)
                                : const AssetImage("assets/images/photo5.png")
                                      as ImageProvider),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildStoreTextField(
                controller: _nameController,
                label: 'اسم المتجر',
                icon: Icons.store,
                validator: (value) =>
                    value!.isEmpty ? 'اسم المتجر مطلوب' : null,
              ),
              const SizedBox(height: 16),
              _buildStoreTextField(
                controller: _bioController,
                label: 'الوصف/البايو',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedGovernorate,
                decoration: InputDecoration(
                  labelText: 'المحافظة',
                  prefixIcon: const Icon(Icons.map_outlined),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _jordanGovernorates
                    .map(
                      (gov) => DropdownMenuItem(
                        value: gov,
                        child: Text(gov, style: GoogleFonts.cairo()),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedGovernorate = val;
                  });
                },
                validator: (value) =>
                    value == null ? 'الرجاء اختيار المحافظة' : null,
              ),

              const SizedBox(height: 16),

              _buildStoreTextField(
                controller: _cityController,
                label: 'المدينة',
                icon: Icons.location_city_outlined,
                validator: (value) => value!.isEmpty ? 'المدينة مطلوبة' : null,
              ),
              const SizedBox(height: 16),

              _buildStoreTextField(
                controller: _phoneController,
                label: 'رقم الهاتف',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'رقم الهاتف مطلوب';
                  if (value.length < 10) return 'يرجى إدخال رقم هاتف صحيح';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              _buildSectionTitle(Icons.access_time_filled, "ساعات العمل"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePickerCard(
                      label: 'من الساعة',
                      time: _openingTime,
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimePickerCard(
                      label: 'إلى الساعة',
                      time: _closingTime,
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Divider(),

              _buildSectionTitle(Icons.color_lens, "ثيم وتصميم المتجر"),
              const SizedBox(height: 16),

              Text(
                'اختر اللون الأساسي لمتجرك:',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildColorOption(Colors.blue),
                  _buildColorOption(Colors.red),
                  _buildColorOption(Colors.green),
                  _buildColorOption(Colors.purple),
                  _buildColorOption(Colors.orange),
                  _buildColorOption(const Color.fromARGB(248, 1, 53, 66)),
                ],
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAllSettings,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'حفظ كافة الإعدادات',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildSectionTitle(IconData icon, String title) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final bool isSelected = _tempSelectedColor?.value == color.value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tempSelectedColor = color;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.black12,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  Widget _buildTimePickerCard({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  time.format(context),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
