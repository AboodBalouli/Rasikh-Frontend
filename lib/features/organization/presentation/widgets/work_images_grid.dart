/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';

class WorkImagesGrid extends StatelessWidget {
  final List<Uint8List> workImages;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemoveTap;

  const WorkImagesGrid({
    super.key,
    required this.workImages,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: workImages.length < 5 ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "صور أعمالك (5 صور بالضبط) *",
                style: TextStyle(
                  fontFamily: AppFonts.parastoo,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${workImages.length}/5",
                style: TextStyle(
                  color: workImages.length < 5 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (workImages.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workImages.length,
                itemBuilder: (context, index) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          workImages[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => onRemoveTap(index),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: workImages.length >= 5 ? null : onAddTap,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text("إضافة صور"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkImagesGrid extends StatelessWidget {
  final List<dynamic> workImages;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemoveTap;

  const WorkImagesGrid({
    super.key,
    required this.workImages,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isUnderLimit = workImages.length < 5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isUnderLimit
            ? Colors.red.withOpacity(0.05)
            : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnderLimit ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "صور أعمالك (5 صور على الأقل) *",
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${workImages.length}/5",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isUnderLimit ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (workImages.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          top: 5,
                          right: 5,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImagePreview(workImages[index]),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onRemoveTap(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                "إضافة صور",
                style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(dynamic imageContent) {
    if (imageContent is Uint8List) {
      return Image.memory(
        imageContent,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else if (imageContent is File) {
      return Image.file(imageContent, width: 80, height: 80, fit: BoxFit.cover);
    } else {
      return const SizedBox(width: 80, height: 80, child: Icon(Icons.error));
    }
  }
}
