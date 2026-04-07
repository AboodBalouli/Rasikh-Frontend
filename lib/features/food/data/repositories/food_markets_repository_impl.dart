import '../../domain/entities/food_market.dart';
import '../../domain/repositories/food_markets_repository.dart';

class FoodMarketsRepositoryImpl implements FoodMarketsRepository {
  @override
  List<FoodMarket> getMarkets() {
    return const [
      FoodMarket(
        name: 'Sweet Corner',
        category: 'حلويات',
        description: 'حلويات يومية طازجة وكعك منزلي.',
        city: 'Gaza',
        rating: 4.6,
        imageUrl: 'https://picsum.photos/400/200?random=11',
      ),
      FoodMarket(
        name: 'Sandwich House',
        category: 'ساندويشات',
        description: 'ساندويشات سريعة مع خيارات صحية.',
        city: 'Rafah',
        rating: 4.2,
        imageUrl: 'https://picsum.photos/400/200?random=12',
      ),
      FoodMarket(
        name: 'Arab Kitchen',
        category: 'عربي',
        description: 'مأكولات عربية ووجبات بيتية.',
        city: 'Khan Younis',
        rating: 4.4,
        imageUrl: 'https://picsum.photos/400/200?random=13',
      ),
      FoodMarket(
        name: 'Fresh Drinks',
        category: 'مشروبات',
        description: 'عصائر طبيعية ومشروبات باردة.',
        city: 'Gaza',
        rating: 4.1,
        imageUrl: 'https://picsum.photos/400/200?random=14',
      ),
    ];
  }
}
