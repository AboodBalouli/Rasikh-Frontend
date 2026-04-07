class StoreInfoModel {
  final String? address;
  final String? phone;
  final String? workingHours;
  final int? totalSales;

  final String? storeName;
  final String? description;
  final double? averageRating;
  final int? ratingCount;
  final String? country;
  final String? government;
  final String? themeColor;
  final List<String>? tags;

  final String? firstName;
  final String? lastName;

  StoreInfoModel({
    this.address,
    this.phone,
    this.workingHours,
    this.totalSales,
    this.storeName,
    this.description,
    this.averageRating,
    this.ratingCount,
    this.country,
    this.government,
    this.themeColor,
    this.tags,
    this.firstName,
    this.lastName,
  });

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    double? readDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? readInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    List<String>? readStringList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    }

    String? readNullableString(String camel, String snake) {
      final v = json.containsKey(camel) ? json[camel] : json[snake];
      return v == null ? null : v.toString();
    }

    return StoreInfoModel(
      address: readNullableString('address', 'address'),
      phone: readNullableString('phone', 'phone_number') ??
          readNullableString('phoneNumber', 'phone_number'),
      workingHours: readNullableString('workingHours', 'working_hours'),
      totalSales: readInt(json['totalSales'] ?? json['total_sales']),

      storeName: readNullableString('storeName', 'store_name'),
      // Backend docs say API field is `description` (stored as Profile.overview).
      // Some older responses may use `storeDescription`.
      description:
          readNullableString('description', 'overview') ??
          readNullableString('storeDescription', 'store_description'),
      averageRating: readDouble(json['averageRating']),
      ratingCount: readInt(json['ratingCount']),
      country: readNullableString('country', 'country'),
      government: readNullableString('government', 'government'),
      themeColor: readNullableString('themeColor', 'theme_color'),
      tags: readStringList(json['tags'] ?? json['storeTags']),

      // These may come from update response shapes; keep nullable.
      firstName: readNullableString('firstName', 'first_name'),
      lastName: readNullableString('lastName', 'last_name'),
    );
  }

  /// For PUT /profile/me/store (partial update)
  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};
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
    if (description != null) data['description'] = description;
    return data;
  }
}
