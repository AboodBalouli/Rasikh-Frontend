import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProofDocumentUploader extends StatelessWidget {
  final Uint8List? proofDocumentBytes;
  final VoidCallback onTap;

  const ProofDocumentUploader({
    super.key,
    required this.proofDocumentBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: proofDocumentBytes == null ? Colors.red.shade300 : Colors.amber,
        ),
      ),
      child: Column(
        children: [
          Text(
            "ارفاق اثبات الجمعية *",
            style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (proofDocumentBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(proofDocumentBytes!, height: 100),
            ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.upload_file),
            label: Text(proofDocumentBytes == null ? "رفع الملف" : "تغيير الملف"),
          ),
        ],
      ),
    );
  }
}

