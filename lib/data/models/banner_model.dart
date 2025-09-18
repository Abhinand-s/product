// Used to represent a banner in the application
// Banners is used in the home screen to show promotional content
import 'package:product/data/models/category_model.dart';
import 'package:product/data/models/product_model.dart';

class BannerModel {
  final int id; // Unique identifier for the banner
  final String imageUrl; // URL of the banner image
  final ProductModel? product; // Associated product, if any
  final CategoryModel? category; // Associated category, if any
  BannerModel({
    required this.id, 
    required this.imageUrl,
    this.product,
    this.category,
  });
// Factory constructor to create a BannerModel from JSON data
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,// Default to 0 if id is missing
      imageUrl: json['image'] ?? '',// Default to empty string if image URL is missing
      // Parse associated product if present
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      // Parse associated category if present
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }
}