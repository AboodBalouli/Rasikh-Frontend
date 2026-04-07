class UpdateOrderStatusRequestModel {
  final String newStatus;

  const UpdateOrderStatusRequestModel({required this.newStatus});

  Map<String, dynamic> toJson() {
    return {'newStatus': newStatus};
  }
}
