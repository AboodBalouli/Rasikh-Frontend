import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<User> getUserById(String id);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<String> uploadProfileImage(String userId, String imagePath);
}
