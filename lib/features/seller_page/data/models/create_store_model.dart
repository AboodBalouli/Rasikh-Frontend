import 'dart:typed_data';

class StoreModel {
  final String name;
  final String description;
  //final String sellerBio;
  final String category;
  final String? subCategory;
  final String location;
  final String phoneNumber;
  final Uint8List logo;
  final Uint8List? healthLicense;
  final List<Uint8List> workSamples;

  StoreModel({
    required this.name,
    required this.description,
    //required this.sellerBio,
    required this.category,
    this.subCategory,
    required this.location,
    required this.phoneNumber,
    required this.logo,
    this.healthLicense,
    required this.workSamples,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      //'seller_bio': sellerBio,
      'category': category,
      'sub_category': subCategory,
      'location': location,
      'phone_number': phoneNumber,
    };
  }
}
