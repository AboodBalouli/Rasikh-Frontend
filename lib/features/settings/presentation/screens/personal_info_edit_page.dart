import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/settings/presentation/user/user_notifier.dart';

class PersonalInfoEditPage extends ConsumerStatefulWidget {
  const PersonalInfoEditPage({super.key});

  @override
  ConsumerState<PersonalInfoEditPage> createState() =>
      _PersonalInfoEditPageState();
}

class _PersonalInfoEditPageState extends ConsumerState<PersonalInfoEditPage> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 22, minute: 0);

  // المتحكمات بالنصوص
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController missionController;
  late TextEditingController workingHoursController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    nameController = TextEditingController(text: user.name ?? '');
    emailController = TextEditingController(text: user.email ?? '');
    phoneController = TextEditingController(text: user.phone ?? '');
    locationController = TextEditingController(text: user.location ?? '');
    missionController = TextEditingController(text: user.mission ?? '');
    workingHoursController = TextEditingController(
      text: user.workingHours ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    missionController.dispose();
    workingHoursController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName مطلوب';
    return null;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userProvider.notifier)
          .updateFullProfile(
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            location: locationController.text,
            mission: missionController.text,
            workingHours: workingHoursController.text,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ بيانات الجمعية بنجاح')),
      );
      context.pop();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();

      ref.read(userImageProvider.notifier).setImage(imageBytes);
      ref.read(userProvider.notifier).updateAvatarFilePath(pickedImage.path);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpening ? _openingTime : _closingTime,
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
        // تحديث الكنترولر بالنص المنسق ليتم حفظه
        workingHoursController.text =
            '${_openingTime.format(context)} - ${_closingTime.format(context)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // اللون الأخضر الخاص بالجمعيات
    const Color charityColor = Color(0xFF2E7D32);
    final pickedImageBytes = ref.watch(userImageProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'تعديل معلومات الجمعية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------------- شعار الجمعية ----------------
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: charityColor.withOpacity(0.1),
                    backgroundImage: pickedImageBytes != null
                        ? MemoryImage(pickedImageBytes)
                        : const AssetImage('assets/images/photo5.png')
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: charityColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'شعار الجمعية الرسمي',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // ---------------- نموذج البيانات ----------------
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: nameController,
                    label: 'اسم الجمعية الرسمي',
                    icon: Icons.account_balance,
                    activeColor: charityColor,
                    validator: (v) => _requiredValidator(v, 'اسم الجمعية'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: emailController,
                    label: 'البريد الإلكتروني للجمعية',
                    icon: Icons.email,
                    activeColor: charityColor,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        _requiredValidator(v, 'البريد الإلكتروني'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: phoneController,
                    label: 'رقم هاتف التواصل',
                    icon: Icons.phone,
                    activeColor: charityColor,
                    keyboardType: TextInputType.phone,
                    validator: (v) => _requiredValidator(v, 'رقم الهاتف'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: missionController,
                    label: 'رسالة الجمعية وأهدافها',
                    icon: Icons.description,
                    activeColor: charityColor,
                    maxLines: 4,
                    validator: (v) => _requiredValidator(v, 'الرسالة'),
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'ساعات العمل الرسمية',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerCard(
                          label: 'من الساعة',
                          time: _openingTime,
                          activeColor: charityColor,
                          onTap: () => _selectTime(context, true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTimePickerCard(
                          label: 'إلى الساعة',
                          time: _closingTime,
                          activeColor: charityColor,
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: locationController,
                    label: 'الموقع (المدينة - الحي)',
                    icon: Icons.location_on,
                    activeColor: charityColor,
                    validator: (v) => _requiredValidator(v, 'الموقع'),
                  ),
                  const SizedBox(height: 40),

                  // ---------------- زر الحفظ ----------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: charityColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'حفظ البيانات',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color activeColor,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.cairo(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
        floatingLabelStyle: GoogleFonts.cairo(color: activeColor),
        prefixIcon: Icon(icon, color: activeColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: activeColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildTimePickerCard({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time, size: 20, color: activeColor),
                const SizedBox(width: 10),
                Text(
                  time.format(context),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
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
