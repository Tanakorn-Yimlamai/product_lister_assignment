class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String brand; 
  final String category;
  final double rating;
  final List<dynamic> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.brand,
    required this.category,
    required this.rating,
    required this.reviews
  });
  String get reviewCount => reviews.length.toString();
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      brand: json['brand'] as String? ?? 'Premium Selection',
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] ?? [],
      images: List<String>.from(json['images'] ?? [])
    );
  }
}