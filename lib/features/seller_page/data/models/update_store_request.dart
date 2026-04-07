class UpdateStoreRequest {
  final String? address;
  final String? phone;
  final String? workingHours;
  final String? storeName;
  final String? country;
  final String? government;
  final String? themeColor;
  final String? firstName;
  final String? lastName;
  final List<String>? tags;

  const UpdateStoreRequest({
    this.address,
    this.phone,
    this.workingHours,
    this.storeName,
    this.country,
    this.government,
    this.themeColor,
    this.firstName,
    this.lastName,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (address != null) data['address'] = address;
    if (phone != null) data['phone'] = phone;
    if (workingHours != null) data['workingHours'] = workingHours;
    if (storeName != null) data['storeName'] = storeName;
    if (country != null) data['country'] = country;
    if (government != null) data['government'] = government;
    if (themeColor != null) data['themeColor'] = themeColor;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (tags != null) data['tags'] = tags;
    return data;
  }
}
