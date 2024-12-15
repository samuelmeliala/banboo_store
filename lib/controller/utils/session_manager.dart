import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String keyUsername = 'username';
  static const String keyUserId = 'userId';
  static const String keyToken = 'token';

  // Save user session
  static Future<void> saveUserSession(
      String username, String id, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username.toString());
    await prefs.setString(keyUserId, id.toString());
    await prefs.setString(keyToken, token.toString());
  }

  // Get username
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  // Clear session
  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
