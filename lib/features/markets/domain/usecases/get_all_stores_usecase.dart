import '../entities/market_store.dart';
import '../repositories/markets_repository.dart';

class GetAllStoresUsecase {
  final MarketsRepository repository;

  const GetAllStoresUsecase(this.repository);

  Future<List<MarketStore>> call() => repository.fetchStores();
}
