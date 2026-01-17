import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../data/product_modal.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Widget _buildDetailSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white, height: 450, width: double.infinity),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: BackButton(color: Colors.black),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_image_${widget.product.id}',
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.product.images.length,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.product.images[index],
                          fit: BoxFit.contain,
                          placeholder: (context, url) => _buildDetailSkeleton(), // Re-use the widget
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        );
                      },
                    ),
                    if(widget.product.images.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (index) => GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: _currentPage == index ? 12 : 8,
                              width: _currentPage == index ? 12 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index ? Colors.red : Colors.grey[300],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('\$${widget.product.price}', style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 14,
                            color: index < widget.product.rating.floor() ? Colors.red : Colors.grey[300]
                          );
                        })
                      ),
                      Text(
                        '(${widget.product.reviews.length}) รีวิว', 
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  ),
                  const SizedBox(height: 10),
                  Text(widget.product.description, style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}