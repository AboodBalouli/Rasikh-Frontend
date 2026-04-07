import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '/features/products/presentation/providers/providers.dart';

enum UserType { seller, charity }

final userTypeProvider = NotifierProvider<UserTypeNotifier, UserType>(() {
  return UserTypeNotifier();
});

class UserTypeNotifier extends Notifier<UserType> {
  @override
  UserType build() => UserType.seller;

  void setType(UserType type) => state = type;
}
