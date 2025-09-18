// repository for fetching user profile data from the API.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product/data/models/user_profile_model.dart';

class ProfileRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<UserProfile> fetchUserProfile() async {
    try {
      final token = await _storage.read(key: 'jwt_token');

      // --- ADDED FOR DEBUGGING ---
      debugPrint('JWT Token being used: $token');
      // ---------------------------

      if (token == null) {
        // Handle missing token
        throw Exception('Authentication token not found.');
      }

      final response = await _dio.get(
        '$_baseUrl/user-data/',
        options: Options(headers: {
          'Authorization': 'Bearer $token'
        }), // Attach token in headers
      );

      dynamic data = response.data;

      if (data is List && data.isNotEmpty) {
        return UserProfile.fromJson(
            data.first); // Handle case where data is a list
      }

      if (data is Map<String, dynamic>) {
        return UserProfile.fromJson(
            data); // Handle case where data is a single object
      }

      throw Exception('Unexpected profile data format from server.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception(
            'User profile endpoint not found. Please check the URL.'); // 404 Not Found
      }
      throw Exception(
          'Failed to fetch profile: ${e.response?.data['message'] ?? e.message}'); // More detailed error message
    } catch (e) {
      rethrow;
    }
  }
}
