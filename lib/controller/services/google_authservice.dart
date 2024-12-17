import 'package:banboo_store/controller/utils/session_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> _sendGoogleLoginToBackend(
      Map<String, dynamic> userData) async {
    try {
      // print('Sending data to backend: ${json.encode(userData)}'); // Debug log

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/google'), // Updated endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      // print('Response status: ${response.statusCode}'); // Debug log
      // print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }

      throw Exception('Server error: ${response.statusCode}\n${response.body}');
    } catch (e) {
      // print('Network error: $e'); // Debug log
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final userData = {
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'googleId': googleUser.id,
          'profilePicture': googleUser.photoUrl ?? '',
        };

        final response = await _sendGoogleLoginToBackend(userData);

        if (response['token'] != null) {
          await _saveUserSession(response);
          return {
            'success': true,
            'user': googleUser,
            'token': response['token'],
            'message': 'Login successful'
          };
        }

        return {
          'success': false,
          'message': response['message'] ?? 'Failed to authenticate with server'
        };
      }

      return {'success': false, 'message': 'Google sign-in cancelled'};
    } catch (error) {
      // print('Google Sign-In Error: $error');
      return {'success': false, 'message': error.toString()};
    }
  }

  // Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (error) {
      // print('Sign Out Error: $error');
      throw Exception('Failed to sign out');
    }
  }

  // Updated save session method to match backend response
  static Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    try {
      // print('Saving session data:'); // Debug logs
      // print('Token: ${userData['token']}');
      // print('ID: ${userData['id']}');
      // print('Username: ${userData['username']}');
      // print('Email: ${userData['email']}');

      await SessionManager.saveUserSession(
          userData['username']?.toString() ?? '',
          userData['id']?.toString() ?? '',
          userData['token']?.toString() ?? '',
          'user' // default role for Google users
          );
    } catch (e) {
      // print('Error saving session: $e');
      throw Exception('Failed to save session data');
    }
  }
}

// Check if user is logged in
Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token')?.isNotEmpty ?? false;
}
