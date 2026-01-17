import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: double.infinity, height: 16, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 100, height: 14, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 60, height: 20, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}