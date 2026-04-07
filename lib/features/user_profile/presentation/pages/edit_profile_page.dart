import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/user.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/edit_profile_form_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

@immutable
class EditProfilePageArgs {
  final User user;
  final UserController userController;

  const EditProfilePageArgs({required this.user, required this.userController});
}

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  late final EditProfileFormController _formController;

  @override
  void initState() {
    super.initState();
    _formController = EditProfileFormController(widget.user);
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = context.read<UserController>();
    String profileImagePath = widget.user.profileImage;

    if (_imageFile != null) {
      await controller.uploadProfileImage(widget.user.id, _imageFile!.path);
      profileImagePath = _imageFile!.path;
    }

    final updatedUser = _formController.buildUpdatedUser(
      widget.user,
      profileImagePath: profileImagePath,
    );

    await controller.updateUser(updatedUser);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFAFBFA),
      ),
      body: SingleChildScrollView(
        padding: Responsive.paddingAll(context),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: context.sp(50),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (widget.user.profileImage.isNotEmpty
                                    ? (widget.user.profileImage.startsWith(
                                            'http',
                                          )
                                          ? NetworkImage(
                                              widget.user.profileImage,
                                            )
                                          : FileImage(
                                              File(widget.user.profileImage),
                                            ))
                                    : null)
                                as ImageProvider?,
                      child:
                          _imageFile == null && widget.user.profileImage.isEmpty
                          ? Icon(Icons.person, size: context.sp(50))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(context.wp(1)),
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: context.sp(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.hp(3)),
              _buildTextField(
                controller: _formController.nameController,
                label: 'الاسم الكامل',
                icon: Icons.person,
                hint: 'أدخل اسمك الكامل',
                context: context,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسمك الكامل';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                controller: _formController.emailController,
                label: 'البريد الالكتروني',
                icon: Icons.email,
                hint: 'أدخل بريدك الالكتروني',
                context: context,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال بريدك الالكتروني';
                  }
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'يرجى إدخال بريد إلكتروني صالح';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                controller: _formController.phoneController,
                label: 'رقم الهاتف',
                icon: Icons.phone,
                hint: 'أدخل رقم هاتفك',
                context: context,
                keyboardType: TextInputType.phone,
                prefixText: "+962 ",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم هاتفك';
                  }
                  if (value.length != 9) {
                    return 'يجب أن يتكون رقم الهاتف من 9 أرقام';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                controller: _formController.addressController,
                label: 'العنوان',
                icon: Icons.location_on,
                hint: 'أدخل عنوانك',
                context: context,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوانك';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                controller: _formController.cityController,
                label: 'المدينة',
                icon: Icons.location_city,
                hint: 'ادخل اسم المدينة',
                context: context,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى ادخال اسم المدينة';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(2)),
              _buildTextField(
                controller: _formController.countryController,
                label: 'الدولة',
                icon: Icons.public,
                hint: 'ادخل دولتك ',
                context: context,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى ادخال دولتك';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.hp(4)),
              CustomButton(
                height: context.hp(7),
                text: 'حفظ التغييرات',
                onPressed: _saveChanges,
                backgroundColor: TColors.primary,
              ),
              SizedBox(height: context.hp(1.5)),
              CustomButton(
                height: context.hp(7),
                text: 'الغاء',
                onPressed: () => context.pop(),
                backgroundColor: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required BuildContext context,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? prefixText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: TColors.primary, fontSize: context.sp(14)),
        hintText: hint,
        hintStyle: TextStyle(fontSize: context.sp(14)),
        prefixIcon: Icon(icon, color: TColors.primary, size: context.sp(22)),
        prefixText: prefixText,
        prefixStyle: TextStyle(fontSize: context.sp(14)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TColors.primary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TColors.primary.withValues(alpha: 0.3)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.wp(4),
          vertical: context.hp(1.5),
        ),
      ),
    );
  }
}
