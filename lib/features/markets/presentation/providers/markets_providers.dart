import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_application_1/core/network/api_service.dart';
import '../../data/datasources/markets_remote_datasource.dart';
import '../../data/mappers/market_store_mapper.dart';
import '../../data/repositories/markets_repository_impl.dart';
import '../../domain/usecases/get_all_stores_usecase.dart';
import '../controllers/markets_controller.dart';

final marketsControllerProvider =
    ChangeNotifierProvider.autoDispose<MarketsController>((ref) {
      final apiService = ApiService();
      final datasource = MarketsRemoteDatasourceImpl(apiService);
      final repo = MarketsRepositoryImpl(
        remoteDatasource: datasource,
        mapper: const MarketStoreMapper(),
      );
      return MarketsController(getAllStores: GetAllStoresUsecase(repo));
    });
