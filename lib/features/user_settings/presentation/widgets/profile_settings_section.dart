import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_profile_widget.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_loading_widget.dart';
import 'package:flutter_application_1/features/user_profile/presentation/widgets/user_error_widget.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';

class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState
    extends ConsumerState<ProfileSettingsSection> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch after the first frame to ensure ref is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUser();
    });
  }

  void _fetchUser() {
    ref.read(userControllerProvider).fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userControllerProvider);

    // Wrap with Provider for descendants that use context.read<UserController>()
    return p.ChangeNotifierProvider<UserController>.value(
      value: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          // Show loading if explicitly loading OR if no data yet and no error (initial state)
          if (controller.isLoading ||
              (controller.user == null && controller.error == null)) {
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
    );
  }
}
