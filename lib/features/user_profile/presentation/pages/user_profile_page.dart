import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_profile_widget.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_loading_widget.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_error_widget.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  final String? userId;

  const UserProfilePage({super.key, this.userId});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchUser);
  }

  void _fetchUser() {
    final controller = ref.read(userControllerProvider);
    if (widget.userId != null) {
      controller.fetchUserById(widget.userId!);
    } else {
      controller.fetchCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = ref.watch(userControllerProvider);

    // Provide the Riverpod-created controller to existing widgets that
    // still use the `provider` package (Consumer/context.read).
    return p.ChangeNotifierProvider<UserController>.value(
      value: userController,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.profile,
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 83, 148, 93),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFFFAFBFA),
          foregroundColor: TColors.primary,
        ),
        body: p.Consumer<UserController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const UserLoadingWidget();
            }

            if (controller.error != null) {
              return UserErrorWidget(
                error: controller.error ?? 'Unknown error occurred',
                onRetry: _fetchUser,
              );
            }

            if (controller.user == null) {
              return const Center(child: Text('No user data available'));
            }

            return UserProfileWidget(user: controller.user!);
          },
        ),
      ),
    );
  }
}
