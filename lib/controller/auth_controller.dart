import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:banboo_store/models/user_model.dart';

class AuthController {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }
}
