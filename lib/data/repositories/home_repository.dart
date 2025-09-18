// repository for fetching banners and products from the API.
import 'package:dio/dio.dart';
import 'package:product/data/models/banner_model.dart';
import 'package:product/data/models/product_model.dart';

class HomeRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  /// Fetches a list of banners from the API.
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await _dio.get('$_baseUrl/banners/'); //
      // The API returns a list of JSON objects. We map over the list
      // and convert each JSON object into a BannerModel.
      final List<dynamic> data = response.data;
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch banners: ${e.message}');
    }
  }

  /// Fetches a list of products from the API.
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get('$_baseUrl/products/'); //
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    }
  }

  Future<List<ProductModel>> searchProducts({required String query}) async {
    try {
      final response = await _dio.get(
        "https://skilltestflutter.zybotechlab.com/api/search/",
        queryParameters: {"query": query}, // attaches ?query=powder
      );

      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to search products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to search products: $e");
    }
  }
}
