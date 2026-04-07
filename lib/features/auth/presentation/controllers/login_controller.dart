import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import 'login_state.dart';
import 'package:flutter_application_1/core/utils/authentication_regex.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/core/network/auth_exception.dart';
import 'package:flutter_application_1/app/providers/shop_providers.dart';

class LoginController extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;
  final Ref _ref;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  LoginController(this._loginUsecase, this._ref) : super(LoginState.initial()) {
    _initializeControllers();
  }

  void _initializeControllers() {
    emailController = TextEditingController()..addListener(_controllerListener);
    passwordController = TextEditingController()
      ..addListener(_controllerListener);
  }

  void _controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(isFormValid: false);
      return;
    }

    final isValid =
        AuthenticationRegex.emailRegex.hasMatch(email) && password.isNotEmpty;

    state = state.copyWith(isFormValid: isValid);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);
  }

  Future<void> login(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      await _loginUsecase(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Refresh shop data (cart, wishlist) for the logged-in user
      final shopController = _ref.read(shopControllerProvider);
      shopController.refreshWishlist(force: true);
      shopController.refreshCart(force: true);

      SnackbarHelper.showSnackBar('Logged in successfully');
      context.go('/home');
    } on AuthException catch (e) {
      SnackbarHelper.showSnackBar(e.message, isError: true);
    } catch (e) {
      SnackbarHelper.showSnackBar('Unexpected error, try again', isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
