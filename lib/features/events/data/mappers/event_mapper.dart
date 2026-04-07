import 'package:flutter_application_1/features/events/data/models/event_product_model.dart';
import 'package:flutter_application_1/features/events/data/models/event_products_response_model.dart';
import 'package:flutter_application_1/features/events/data/models/event_response_model.dart';
import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_product.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_products.dart';

/// Maps EventResponseModel to Event entity.
Event mapEventResponseToEntity(EventResponseModel model) {
  return Event(
    id: model.id,
    name: model.name,
    description: model.description,
    startDate: model.startDate,
    endDate: model.endDate,
    published: model.published,
    imageUrl: model.imageUrl,
  );
}

/// Maps EventProductModel to EventProduct entity.
EventProduct mapEventProductModelToEntity(EventProductModel model) {
  return EventProduct(
    id: model.id,
    name: model.name,
    description: model.description,
    price: model.price,
    rating: model.rating,
    ratingCount: model.ratingCount,
    totalSales: model.totalSales,
    sellerProfileId: model.sellerProfileId,
    sellerUserId: model.sellerUserId,
    sellerName: model.sellerName,
    tags: model.tags,
    imagePaths: model.imagePaths,
    categoryName: model.categoryName,
  );
}

/// Maps EventProductsResponseModel to EventProducts entity.
EventProducts mapEventProductsResponseToEntity(
  EventProductsResponseModel model,
) {
  return EventProducts(
    eventId: model.eventId,
    eventName: model.eventName,
    matchedTags: model.matchedTags,
    products: model.products.map(mapEventProductModelToEntity).toList(),
  );
}
