// authentication repository to handle API calls for phone verification and login/registration
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  /// Verifies phone number. Returns TRUE if the user is NEW, FALSE if they EXIST.
  Future<Map<String, dynamic>> verifyPhoneNumber(
      {required String phoneNumber}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/verify/',
        data: {'phone_number': phoneNumber},
      );

      if (response.data != null && response.data['user'] is bool) {
        // The API returns 'user: false' for a NEW user.
        // We want to return 'isNewUser: true' in that case.
        // So we return the opposite of what the server gives us.
        bool userExists = response.data['user'];
        final otpValue = response.data['otp'];
        final int parsedOtp = int.tryParse(otpValue.toString()) ?? 0;
        return {
          'isNewUser': !userExists,
          'otp': parsedOtp
        }; // !false is true (is a new user)
      }
      // Default to assuming the user exists if the key is missing.
      throw Exception('Invalid response from verify API');
    } on DioException catch (e) {
      throw Exception('Failed to verify phone number: ${e.message}');
    }
  }

  Future<String> loginOrRegister({
    required String phoneNumber,
    String? firstName,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login-register/',
        data: {
          'phone_number': phoneNumber,
          'first_name': firstName,
        },
      );

      final responseData = response.data;
      // print('Full response from /login-register/: $responseData');
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('token')) {
          final tokenData = responseData['token'];
          // Check if the token data is a Map and contains the 'access' key
          if (tokenData is Map<String, dynamic> &&
              tokenData.containsKey('access')) {
            final accessToken = tokenData['access'];
            // Ensure the access token is a string before returning
            if (accessToken is String) {
              return accessToken; // Success!
            }
          }
        }
      }
      // If any of the checks above fail, throw an error.
      throw Exception(
          'Login failed: Could not extract a valid token from the response.');
    } on DioException catch (e) {
      final errorMsg =
          (e.response?.data as Map<String, dynamic>?)?['message']?.toString() ??
              e.message ??
              'An unknown error occurred';
      throw Exception('API Error: $errorMsg');
    } catch (e) {
      rethrow;
    }
  }
}
