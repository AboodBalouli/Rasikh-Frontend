import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/network/api_service.dart';

import '../../data/datasources/forgot_password_remote_datasource.dart';
import '../../data/repositories/forgot_password_repository_impl.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final forgotPasswordRemoteProvider = Provider<ForgotPasswordRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiServiceProvider);
  return ForgotPasswordRemoteDataSource(api);
});

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>((
  ref,
) {
  final remote = ref.read(forgotPasswordRemoteProvider);
  return ForgotPasswordRepositoryImpl(remote);
});

final requestResetOtpUseCaseProvider = Provider<RequestResetOtpUseCase>((ref) {
  return RequestResetOtpUseCase(ref.read(forgotPasswordRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.read(forgotPasswordRepositoryProvider));
});
