import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;

  const ProductImage({super.key, required this.imagePath});

  String _resolveImageUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = imagePath.trim();
    final isAsset =
        trimmed.startsWith('assets/') &&
        !trimmed.contains('/images/') &&
        !trimmed.contains('images/product/');

    final resolved = trimmed.isEmpty
        ? 'assets/images/cat1.jpg'
        : (isAsset ? trimmed : _resolveImageUrl(trimmed));

    final imageSize = Responsive.isTablet(context)
        ? context.wp(30)
        : context.wp(55);

    return Center(
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: AppImage(
            imageUrl: resolved,
            fit: BoxFit.cover,
            isNetworkImage: !isAsset,
          ),
        ),
      ),
    );
  }
}
