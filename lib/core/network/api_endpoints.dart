/// Centralized endpoints used by some of the migrated coworker features.
///
/// NOTE: These are best-effort and may need alignment with your backend.
class ApiEndpoints {
  const ApiEndpoints._();

  // Profile
  static const String profileStores = '/profile/stores';

  // Products
  static const String products = '/api/product/getAll';
  static String productById(String id) => '/api/product/getById/$id';
  static String productsBySellerId(String sellerId) =>
      '/api/product/sellers-products/$sellerId';

  // Seller
  static String sellerById(String id) => '/api/seller/$id';

  // Settings / Store
  static String updateStore(String id) => '/api/store/$id';

  // Auth
  static const String requestPasswordReset = '/auth/password-reset/request';
  // Forgot-password reset (OTP)
  // Backend: UserController @RequestMapping("/users") + @PostMapping("/password/reset")
  static const String resetPassword = '/users/password/reset';
}
