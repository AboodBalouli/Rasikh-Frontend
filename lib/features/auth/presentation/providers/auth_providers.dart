export 'package:flutter_application_1/app/dependency_injection/auth_dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/auth_dependency_injection.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUsecase(repo);
});

