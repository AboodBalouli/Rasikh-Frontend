import '../../domain/entities/market_store.dart';
import '../../domain/repositories/markets_repository.dart';
import '../datasources/markets_remote_datasource.dart';
import '../mappers/market_store_mapper.dart';

class MarketsRepositoryImpl implements MarketsRepository {
  final MarketsRemoteDatasource remoteDatasource;
  final MarketStoreMapper mapper;

  const MarketsRepositoryImpl({
    required this.remoteDatasource,
    required this.mapper,
  });

  @override
  Future<List<MarketStore>> fetchStores() async {
    final models = await remoteDatasource.fetchStores();
    return models.map(mapper.toEntity).toList();
  }
}
