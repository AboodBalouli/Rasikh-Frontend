import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../domain/entities/forgot_password_entities.dart';
import '../providers/forgot_password_providers.dart';
import 'forgot_password_state.dart';

class ForgotPasswordController extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  void updateEmail(String email) => state = state.copyWith(email: email);

  void updateOtp(String otp) => state = state.copyWith(otp: otp);

  Future<bool> sendOtp() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final email = state.email.trim();
      await ref.read(requestResetOtpUseCaseProvider).call(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      debugPrint('ForgotPasswordController.sendOtp error: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String newPassword) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final payload = ResetPasswordEntity(
        email: state.email.trim(),
        otp: state.otp.trim(),
        newPassword: newPassword,
      );

      await ref.read(resetPasswordUseCaseProvider).call(payload);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      debugPrint('ForgotPasswordController.resetPassword error: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordController, ForgotPasswordState>(
      ForgotPasswordController.new,
    );
