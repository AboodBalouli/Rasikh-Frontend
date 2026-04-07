import '../entities/market_store.dart';

abstract class MarketsRepository {
  Future<List<MarketStore>> fetchStores();
}
