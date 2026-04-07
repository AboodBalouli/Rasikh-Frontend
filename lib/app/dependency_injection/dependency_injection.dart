import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_application_1/core/storage/secure_storage_token_provider.dart';
import 'package:flutter_application_1/features/user_profile/data/datasources/user_profile_remote_datasource.dart';
import 'package:flutter_application_1/features/user_profile/data/repositories/profile_user_repository.dart';
import 'package:flutter_application_1/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_current_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_user_by_id.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/upload_profile_image.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/pages/user_profile_page.dart';

Widget buildUserProfilePageWithDependencies() {
  final client = http.Client();
  final tokenProvider = SecureStorageTokenProvider();
  final profileRemote = ProfileRemoteDatasource(
    client: client,
    tokenProvider: tokenProvider,
  );
  final profileRepository = UserProfileRepositoryImpl(profileRemote);
  final repository = ProfileUserRepository(profileRepository);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserController(
          getCurrentUser: GetCurrentUser(repository),
          getUserById: GetUserById(repository),
          updateUser: UpdateUser(repository),
          uploadProfileImage: UploadProfileImage(repository),
        ),
      ),
    ],
    child: const UserProfilePage(),
  );
}
