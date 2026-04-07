import '../../domain/entities/craft_market.dart';
import '../../domain/repositories/craft_markets_repository.dart';

class CraftMarketsRepositoryImpl implements CraftMarketsRepository {
  @override
  List<CraftMarket> getMarkets() {
    return const [
      CraftMarket(
        name: 'Stitch Studio',
        category: 'خياطة',
        description: 'خياطة وتطريز يدوي حسب الطلب.',
        city: 'Gaza',
        rating: 4.7,
        imageUrl: 'https://picsum.photos/400/200?random=21',
      ),
      CraftMarket(
        name: 'Candle Lab',
        category: 'شموع',
        description: 'شموع عطرية وديكور للمناسبات.',
        city: 'Rafah',
        rating: 4.3,
        imageUrl: 'https://picsum.photos/400/200?random=22',
      ),
      CraftMarket(
        name: 'Art Brush',
        category: 'رسم',
        description: 'لوحات وهدايا فنية مرسومة يدوياً.',
        city: 'Khan Younis',
        rating: 4.5,
        imageUrl: 'https://picsum.photos/400/200?random=23',
      ),
      CraftMarket(
        name: 'Wood Works',
        category: 'نجارة',
        description: 'قطع خشبية وأثاث صغير حسب الطلب.',
        city: 'Gaza',
        rating: 4.1,
        imageUrl: 'https://picsum.photos/400/200?random=24',
      ),
    ];
  }
}
