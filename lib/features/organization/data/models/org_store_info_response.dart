class OrgStoreInfoResponse {
  final String? phone;
  final String? country;
  final String? government;
  final double? averageRating;
  final int? ratingCount;

  const OrgStoreInfoResponse({
    this.phone,
    this.country,
    this.government,
    this.averageRating,
    this.ratingCount,
  });

  factory OrgStoreInfoResponse.fromJson(Map<String, dynamic> json) {
    double? readDouble(String key) {
      final v = json[key];
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '');
    }

    int? readInt(String key) {
      final v = json[key];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '');
    }

    String? readString(String key) {
      final v = json[key];
      return v == null ? null : v.toString();
    }

    return OrgStoreInfoResponse(
      phone: readString('phone'),
      country: readString('country'),
      government: readString('government'),
      averageRating: readDouble('averageRating'),
      ratingCount: readInt('ratingCount'),
    );
  }
}
