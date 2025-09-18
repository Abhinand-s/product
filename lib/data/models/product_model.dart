//product model class with sorting by latest
class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final String offerPrice;
  final double rating;
  final bool inWishlist; 
  final DateTime createdDate; 

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.offerPrice,
    required this.rating,
    required this.inWishlist,
    required this.createdDate, 
  });
// copy with method to update inWishlist
  ProductModel copyWith({bool? inWishlist}) {
    return ProductModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      offerPrice: offerPrice,
      rating: rating,
      inWishlist: inWishlist ?? this.inWishlist,
      createdDate: createdDate, 
    );
  }
// from json method with null safety and default values
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Product',
      imageUrl: json['featured_image'] ?? '',
      price: json['mrp']?.toString() ?? '0',
      offerPrice: json['sale_price']?.toString() ?? '0',
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      inWishlist: json['in_wishlist'] ?? false,
      createdDate: DateTime.tryParse(json['created_date'] ?? '') ?? DateTime.now(),
    );
  }
}