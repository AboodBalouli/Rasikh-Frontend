import 'models/order_model.dart';

final List<OrderModel> demoOrders = [
  OrderModel(
    id: 'order_001',
    shopName: 'متجر الحرف اليدوية',
    shopImageUrl:
        'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=200&q=60',
    receivedAt: 'تم الاستلام · 20 نوفمبر',
    status: OrderStatus.delivered,
    rating: 0,
    totalPrice: 75.0,
    items: [
      OrderItem(
        name: 'شمعة معطرة',
        quantity: 1,
        price: 25.0,
        imageUrl:
            'https://images.unsplash.com/photo-1602526216430-d2d4b0c1b7d2?auto=format&fit=crop&w=200&q=60',
      ),
      OrderItem(
        name: 'كوب خزف يدوي',
        quantity: 2,
        price: 25.0,
        imageUrl:
            'https://images.unsplash.com/photo-1582582494700-55f5f6b9c4b1?auto=format&fit=crop&w=200&q=60',
      ),
    ],
  ),
  OrderModel(
    id: 'order_002',
    shopName: 'مخبز البيت',
    shopImageUrl:
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93',
    receivedAt: 'تم الاستلام · 15 نوفمبر',
    status: OrderStatus.processing,
    rating: 0, // ⭐ مقيم مسبقًا
    totalPrice: 40.0,
    items: [
      OrderItem(
        name: 'كيك شوكولاتة',
        quantity: 1,
        price: 20.0,
        imageUrl:
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
      ),
      OrderItem(
        name: 'تشيزكيك',
        quantity: 1,
        price: 20.0,
        imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307',
      ),
    ],
  ),
];
