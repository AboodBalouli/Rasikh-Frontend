import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import '/core/entities/product_card_model.dart';
import 'package:flutter/foundation.dart';

class ProductCard extends StatefulWidget {
  final ProductCardModel productCardModel;
  final VoidCallback onDelete;
  final VoidCallback onHide;
  final VoidCallback onEdit;
  final Function(String newDiscountPrice) onUpdateDiscount;

  const ProductCard({
    super.key,
    required this.productCardModel,
    required this.onDelete,
    required this.onHide,
    required this.onEdit,
    required this.onUpdateDiscount,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;

  ProductCardModel get productCardModel => widget.productCardModel;
  VoidCallback get onDelete => widget.onDelete;
  VoidCallback get onHide => widget.onHide;
  VoidCallback get onEdit => widget.onEdit;
  Function(String newDiscountPrice) get onUpdateDiscount => widget.onUpdateDiscount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool hasDiscount =
        productCardModel.isDiscounted &&
        productCardModel.discountPrice != null &&
        productCardModel.discountPrice!.isNotEmpty;

    final String finalPrice = hasDiscount
        ? productCardModel.discountPrice!
        : productCardModel.originalPrice;

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- الصورة ----------
          InkWell(
            onTap: () => _showProductDetails(context),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Opacity(
                  opacity: productCardModel.hidden ? 0.3 : 1,
                  child: _buildImageCarousel(),
                ),
              ),
            ),
          ),

          // ---------- بيانات المنتج ----------
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productCardModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        productCardModel.category ?? "بدون فئة",
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        productCardModel.description ?? "لا يوجد وصف",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 9,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ---------- قسم السعر في الواجهة ----------
                      if (hasDiscount) ...[
                        Text(
                          "$finalPrice JD",
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        Text(
                          "${productCardModel.originalPrice} JD",
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else
                        Text(
                          "$finalPrice JD",
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                // Edit/Hide menu button
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  offset: const Offset(0, -100),
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 83, 148, 93),
                          const Color.fromARGB(255, 83, 148, 93).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'hide') onHide();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 83, 148, 93).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: Color.fromARGB(255, 83, 148, 93),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "تعديل المنتج",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'hide',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: productCardModel.hidden
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                productCardModel.hidden
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 18,
                                color: productCardModel.hidden
                                    ? Colors.blue
                                    : Colors.orange[700],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              productCardModel.hidden ? "إظهار المنتج" : "إخفاء المنتج",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context) {
    final bool hasDiscount =
        productCardModel.discountPrice != null &&
        productCardModel.discountPrice!.isNotEmpty;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable image carousel for dialog
                _buildDialogImageCarousel(context),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          productCardModel.category ?? "بدون فئة",
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        productCardModel.title,
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            hasDiscount
                                ? "${productCardModel.discountPrice} JD"
                                : "${productCardModel.originalPrice} JD",
                            style: GoogleFonts.cairo(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: hasDiscount
                                  ? Colors.redAccent
                                  : Colors.green[700],
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 12),
                            Text(
                              productCardModel.originalPrice,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(thickness: 0.8),
                      ),

                      Text(
                        "الوصف",
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 100),
                        child: SingleChildScrollView(
                          child: Text(
                            productCardModel.description ??
                                "لا يوجد وصف متوفر لهذا المنتج حالياً.",
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (productCardModel.tags != null &&
                          productCardModel.tags!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: productCardModel.tags!
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.blueGrey.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.tag,
                                        size: 12,
                                        color: Colors.blueGrey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tag,
                                        style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueGrey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogImageCarousel(BuildContext context) {
    final images = productCardModel.imagePaths ?? [];
    
    // If no images, fall back to single image
    if (images.isEmpty) {
      return Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: _buildProductImage(),
          ),
          _buildCloseButton(context),
        ],
      );
    }
    
    // If only one image
    if (images.length == 1) {
      return Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: _buildSingleImage(images.first),
          ),
          _buildCloseButton(context),
        ],
      );
    }
    
    // Multiple images: use StatefulBuilder for local state
    int dialogImageIndex = 0;
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return Stack(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) {
                  setDialogState(() {
                    dialogImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildSingleImage(images[index]);
                },
              ),
            ),
            // Page indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dialogImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Image counter
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${dialogImageIndex + 1}/${images.length}',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildCloseButton(context),
          ],
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = productCardModel.imagePaths ?? [];
    
    // If no images in list, fall back to single image
    if (images.isEmpty) {
      return _buildProductImage();
    }
    
    // If only one image, show it directly without carousel
    if (images.length == 1) {
      return _buildSingleImage(images.first);
    }
    
    // Multiple images: show PageView carousel
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _buildSingleImage(images[index]);
          },
        ),
        // Page indicators
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        // Image counter badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${images.length}',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImage(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported),
      );
    }

    final rawPath = imagePath.trim();
    final isAsset = rawPath.startsWith('assets/') &&
        !rawPath.contains('/images/') &&
        !rawPath.contains('images/product/');
    
    if (isAsset) {
      return Image.asset(
        rawPath,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    final url = _resolveImageUrl(rawPath);
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }

  Widget _buildProductImage() {
    if (productCardModel.imagePath != null &&
        productCardModel.imagePath!.trim().isNotEmpty) {
      final rawPath = productCardModel.imagePath!.trim();

      // If path is a real asset and not a backend image path, load asset.
      final isAsset = rawPath.startsWith('assets/') &&
          !rawPath.contains('/images/') &&
          !rawPath.contains('images/product/');
      if (isAsset) {
        return Image.asset(
          rawPath,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }

      final url = _resolveImageUrl(rawPath);
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
    if (kIsWeb) {
      if (productCardModel.imageFile != null &&
          productCardModel.imageFile is Uint8List) {
        return Image.memory(
          productCardModel.imageFile as Uint8List,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Icon(Icons.image, size: 40, color: Colors.grey),
      );
    }
    if (productCardModel.imageFile != null) {
      if (productCardModel.imageFile is Uint8List) {
        return Image.memory(
          productCardModel.imageFile as Uint8List,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }
      return Image.file(
        productCardModel.imageFile,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported),
    );
  }

  String _resolveImageUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('http')) return trimmed;
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  void _showDiscountDialog(BuildContext context) {
    final bool hasDiscount =
        productCardModel.discountPrice != null &&
        productCardModel.discountPrice!.isNotEmpty;

    final controller = TextEditingController(
      text: hasDiscount ? productCardModel.discountPrice : "",
    );

    final originalPrice = parsePrice(productCardModel.originalPrice);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        title: Row(
          children: [
            Icon(Icons.percent, color: Colors.orange[800]),
            const SizedBox(width: 8),
            Text(
              hasDiscount ? "تعديل الخصم" : "إضافة خصم",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "السعر بعد الخصم",
                suffixText: "JD",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "السعر الأصلي: ${productCardModel.originalPrice}  JD",
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () {
              if (hasDiscount) onUpdateDiscount("");
              context.pop();
            },
            child: Text(
              hasDiscount ? "إلغاء الخصم" : "إغلاق",
              style: GoogleFonts.cairo(
                color: hasDiscount ? Colors.red : Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              final newPrice = parsePrice(controller.text);
              if (newPrice == null || originalPrice == null) {
                _showError(context, "يرجى إدخال رقم صحيح");
                return;
              }
              if (newPrice >= originalPrice) {
                _showError(
                  context,
                  "يجب أن يكون السعر بعد الخصم أقل من السعر الأصلي",
                );
                return;
              }
              onUpdateDiscount(controller.text.trim());
              context.pop();
            },
            child: Text(
              "حفظ",
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double? parsePrice(String input) {
    if (input.isEmpty) return null;
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    input = input.replaceAll(RegExp(r'[^\d.,]'), '');
    input = input.replaceAll(',', '.');
    try {
      return double.parse(input);
    } catch (_) {
      return null;
    }
  }

  Widget _buildPopupMenu(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'hide') onHide();
        // if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'edit', child: Text("تعديل")),
        PopupMenuItem(value: 'hide', child: Text("إخفاء / إظهار")),

        //   PopupMenuItem(
        //   value: 'delete',
        //   child: Text("حذف", style: TextStyle(color: Colors.red)),
        //   ),
      ],
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
