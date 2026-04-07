import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/authentication_regex.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/core/network/auth_exception.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:go_router/go_router.dart';

class RegisterController {
  final RegisterUsecase _registerUsecase;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  RegisterController(this._registerUsecase);

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);

    lastNameController = TextEditingController()
      ..addListener(controllerListener);

    emailController = TextEditingController()..addListener(controllerListener);

    passwordController = TextEditingController()
      ..addListener(controllerListener);

    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    isLoading.dispose();
  }

  void controllerListener() {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return;
    }

    fieldValidNotifier.value =
        AuthenticationRegex.emailRegex.hasMatch(email) &&
        AuthenticationRegex.passwordRegex.hasMatch(password) &&
        AuthenticationRegex.firstNameRegex.hasMatch(firstName) &&
        AuthenticationRegex.lastNameRegex.hasMatch(lastName);
  }

  Future<void> register(BuildContext context) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;

      await _registerUsecase(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      SnackbarHelper.showSnackBar("Registered Successfully");

      context.go("/login");
    } on AuthException catch (e) {
      print("error auth exception ${e.message}");
      SnackbarHelper.showSnackBar(e.message, isError: true);
    } catch (e) {
      SnackbarHelper.showSnackBar("Unexpected error, try again", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
