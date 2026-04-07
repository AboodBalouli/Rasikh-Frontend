import 'package:flutter_application_1/core/utils/temp_pics.dart';
import 'package:flutter_application_1/features/seasons/data/models/promo_banner.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //static HomeController get instance => Get.find();

  final carouselCurrentIndex = 0.obs;

  void updatePageIndicator(int index) {
    carouselCurrentIndex.value = index;
  }

  final List<PromoBanner> promoBanners = [
    PromoBanner(imageUrl: TempPics.promoBanners[1], seasonKey: 'olive'),
    PromoBanner(imageUrl: TempPics.promoBanners[0], seasonKey: 'olive'),
  ];
}
