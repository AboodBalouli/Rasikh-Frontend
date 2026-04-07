import 'package:flutter_riverpod/legacy.dart';

/// Hover state for product cards (per product id).
final organizationProductHoverProvider = StateProvider.family<bool, String>(
  (ref, productId) => false,
);
