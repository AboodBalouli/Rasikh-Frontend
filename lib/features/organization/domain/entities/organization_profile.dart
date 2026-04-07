class OrganizationProfile {
  final String name;
  final String description;
  final String email;
  final String phone;
  final String address;
  final String website;
  final String? logoPath;
  final List<String> socialLinks;

  const OrganizationProfile({
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.website,
    this.logoPath,
    this.socialLinks = const [],
  });

  OrganizationProfile copyWith({
    String? name,
    String? description,
    String? email,
    String? phone,
    String? address,
    String? website,
    String? logoPath,
    List<String>? socialLinks,
  }) {
    return OrganizationProfile(
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      website: website ?? this.website,
      logoPath: logoPath ?? this.logoPath,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  factory OrganizationProfile.empty() => const OrganizationProfile(
    name: '',
    description: '',
    email: '',
    phone: '',
    address: '',
    website: '',
  );
}
