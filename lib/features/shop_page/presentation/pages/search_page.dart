import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/made_with_love.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/widgets/app_image.dart';
import 'product_detail_page.dart';

@immutable
class SearchPageArgs {
  final List<Product> products;
  final Map<Product, int> cartItems;
  final Function(Product, int) onUpdateQuantity;
  final VoidCallback onOpenCart;
  final List<Product> wishlist;
  final Function(Product) onToggleWishlist;

  const SearchPageArgs({
    required this.products,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onOpenCart,
    required this.wishlist,
    required this.onToggleWishlist,
  });
}

class SearchPage extends StatefulWidget {
  final List<Product> products;
  final Map<Product, int> cartItems;
  final Function(Product, int) onUpdateQuantity;
  final VoidCallback onOpenCart;
  final List<Product> wishlist;
  final Function(Product) onToggleWishlist;

  const SearchPage({
    super.key,
    required this.products,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onOpenCart,
    required this.wishlist,
    required this.onToggleWishlist,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void _updateSearch(String query) {
    setState(() {
      _filteredProducts = widget.products
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: CustomBackButton()),
        title: const MadeWithLove(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: _updateSearch,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 60, 49, 34),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: AppFonts.parastoo,
                    ),
                  ),
                  subtitle: Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: AppFonts.parastoo,
                    ),
                  ),
                  trailing: Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 151, 130, 94),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.7,
                        minChildSize: 0.4,
                        maxChildSize: 0.9,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: ProductDetailPage(
                                product: product,
                                isFavorite: widget.wishlist.contains(product),
                                onFavoriteToggle: () =>
                                    widget.onToggleWishlist(product),
                                scrollController: scrollController,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
