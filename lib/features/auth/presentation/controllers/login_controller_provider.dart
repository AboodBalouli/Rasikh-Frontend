import 'package:flutter_application_1/features/auth/presentation/controllers/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_application_1/app/dependency_injection/auth_dependency_injection.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/login_controller.dart';

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUsecase(repo);
});

// Login controller provider
final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
      final usecase = ref.watch(loginUsecaseProvider);
      return LoginController(usecase, ref);
    });
