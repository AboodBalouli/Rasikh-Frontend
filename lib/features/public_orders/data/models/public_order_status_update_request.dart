class PublicOrderStatusUpdateRequest {
  final String status;

  const PublicOrderStatusUpdateRequest({required this.status});

  Map<String, dynamic> toJson() => {'status': status};
}
