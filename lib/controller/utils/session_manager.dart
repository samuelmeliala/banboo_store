import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String keyUsername = 'username';
  static const String keyUserId = 'userId';
  static const String keyToken = 'token';
  static const String keyRole = 'role';
  static const String keyIsLoggedIn = 'isLoggedIn';

  // Save complete user session
  static Future<void> saveUserSession(
    String username,
    String id,
    String token,
    String role,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyUserId, id);
    await prefs.setString(keyToken, token);
    await prefs.setString(keyRole, role);
    await prefs.setBool(keyIsLoggedIn, true);
  }

  // Get username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyToken);
    return token;
  }

  // Get role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole) == 'admin';
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUsername);
    await prefs.remove(keyUserId);
    await prefs.remove(keyToken);
    await prefs.remove(keyRole);
    await prefs.remove(keyIsLoggedIn);
  }

  // Update specific session data
  static Future<void> updateUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
  }

  static Future<void> updateToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  // Get all session data
  static Future<Map<String, String?>> getAllSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(keyUsername),
      'userId': prefs.getString(keyUserId),
      'token': prefs.getString(keyToken),
      'role': prefs.getString(keyRole),
    };
  }
}
