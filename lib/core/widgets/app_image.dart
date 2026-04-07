import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';

class AppImage extends StatelessWidget {
  final double? width, height;
  final String imageUrl;
  final BoxBorder? border;
  final Color? color;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool? isNetworkImage;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool applyImageRadius;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.applyImageRadius = false,
    this.border,
    this.color,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage,
    this.onTap,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = Sizes.md,
  });

  bool _looksLikeNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    final useNetwork = isNetworkImage ?? _looksLikeNetworkUrl(imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border,
          color: color,
          // borderRadius: BorderRadius.circular(borderRadius),
        ),

        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: Image(
            fit: fit,
            image: useNetwork
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
          ),
        ),
      ),
    );
  }
}
