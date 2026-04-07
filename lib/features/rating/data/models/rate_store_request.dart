/// Request body for POST /profile/stores/{sellerProfileId}/rate
class RateStoreRequest {
  final int rating;
  final String? comment;

  const RateStoreRequest({required this.rating, this.comment});

  Map<String, dynamic> toJson() {
    return {'rating': rating, if (comment != null) 'comment': comment};
  }
}
