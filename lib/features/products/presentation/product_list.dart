import 'package:flutter/material.dart';
import 'package:product_sell_app/features/products/data/product_modal.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_provider.dart';
import 'widgets/product_skeleton.dart';
import 'product_detail.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();

      provider.addListener(() {
      if (provider.state == ProductState.error) {
          _showErrorPopup(context, provider);
        }
      });

      provider.fetchProducts();
    });
  }

  void _showErrorPopup(BuildContext context, ProductProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("เกิดข้อผิดพลาด"),
          ],
        ),
        content: Text(provider.errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              provider.fetchProducts(); 
            },
            child: const Text("ลองใหม่อีกครั้ง", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,     
          elevation: 0,
          title: Text(
            'Shop name', 
            style: TextStyle(
              color: Colors.red, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 3
            )
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,        
              floating: true,       
              snap: true,          
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              scrolledUnderElevation: 0,     
              elevation: 0,
              expandedHeight: 60.0,
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    onChanged: (v) => context.read<ProductProvider>().updateSearchQuery(v),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาไอเทม...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), 
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey, 
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.state == ProductState.loading) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.6, 
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const ProductSkeleton(), 
                        childCount: 8, 
                      ),
                    ),
                  );
                } else if (provider.state == ProductState.error && provider.filteredProducts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text("Error loading data. Check the popup above.", style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                final displayList = provider.filteredProducts;
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = displayList[index];
                        return _ProductCard(product: product);
                      },
                      childCount: displayList.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color.fromRGBO(249, 249, 249, 1),
      highlightColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 249, 249, 1), 
              borderRadius: BorderRadius.circular(16), 
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Hero(
                tag: 'product_image_${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const ProductSkeleton(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 14,
                        color: index < product.rating.floor() ? Colors.red : Colors.grey[300]
                      );
                    })
                  ),
                  Text(
                    '(${product.reviews.length}) รีวิว', 
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ]
              ),
              Text(product.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text('\$${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          
        ],
      ),
      
    );
  }
}