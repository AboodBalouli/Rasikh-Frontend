import 'package:flutter_riverpod/legacy.dart';

import '../../data/repositories/food_markets_repository_impl.dart';
import '../controllers/food_markets_provider.dart';

final foodMarketsProvider = ChangeNotifierProvider<FoodMarketsProvider>((ref) {
  return FoodMarketsProvider(FoodMarketsRepositoryImpl());
});
