import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/user_profile/domain/entities/user.dart';

class EditProfileFormController {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController countryController;

  EditProfileFormController(User user)
    : nameController = TextEditingController(text: user.name),
      emailController = TextEditingController(text: user.email),
      phoneController = TextEditingController(text: user.phone),
      addressController = TextEditingController(text: user.address),
      cityController = TextEditingController(text: user.city),
      countryController = TextEditingController(text: user.country);

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
  }

  User buildUpdatedUser(User original, {required String profileImagePath}) {
    return original.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      city: cityController.text,
      country: countryController.text,
      profileImage: profileImagePath,
    );
  }
}
