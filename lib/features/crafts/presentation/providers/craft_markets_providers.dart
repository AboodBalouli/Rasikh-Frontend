import 'package:flutter_riverpod/legacy.dart';

import '../../data/repositories/craft_markets_repository_impl.dart';
import '../controllers/craft_markets_provider.dart';

final craftMarketsProvider = ChangeNotifierProvider<CraftMarketsProvider>((
  ref,
) {
  return CraftMarketsProvider(CraftMarketsRepositoryImpl());
});
