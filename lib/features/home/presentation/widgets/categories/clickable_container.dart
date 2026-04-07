import 'package:flutter/material.dart';

class ClickableContainer extends StatelessWidget {
  final dynamic T;
  final String name;
  final Color bgColor;
  final VoidCallback? onTap;

  const ClickableContainer({
    required this.T,
    required this.name,
    this.onTap,
    this.bgColor = Colors.transparent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   borderRadius: borderRadius,
          //   border: Border.all(color: Colors.grey.shade300),
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: T is IconData
                      ? Icon(T as IconData, size: 30, color: Colors.white)
                      : T as Widget,
                ),
              ),
              const SizedBox(height: 8),

              /*Text(
                name,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),*/
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
