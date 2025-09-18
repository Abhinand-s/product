// repository for managing the user's wishlist.
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product/data/models/product_model.dart';

class WishlistRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<Options> _getAuthenticatedOptions() async {
    final token =
        await _storage.read(key: 'jwt_token'); // Read token from secure storage
    if (token == null) {
      throw Exception('Authentication token not found.');
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// Fetches the user's wishlist items.
  Future<List<ProductModel>> fetchWishlistItems() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/wishlist/',
        options: await _getAuthenticatedOptions(),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch wishlist: ${e.message}');
    }
  }

  /// Adds or removes an item from the wishlist.
  Future<void> toggleWishlistItem({required int productId}) async {
    try {
      await _dio.post(
        '$_baseUrl/add-remove-wishlist/',
        data: {'product_id': productId},
        options: await _getAuthenticatedOptions(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update wishlist: ${e.message}');
    }
  }
}
