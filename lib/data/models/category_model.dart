// Used to represent a category in the application
// Categories are used to classify products
class CategoryModel {
  final int id; // Unique identifier for the category
  final String name; // Name of the category
  final String imageUrl; // URL of the category image

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
// Factory constructor to create a CategoryModel from JSON data
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}