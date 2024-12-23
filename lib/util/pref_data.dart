import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static const String _usernameKey = "username";
  static const String _idKey = "id";
  static const String _permission = "isPrermitted";
  static String isIntro = "${getUsername()}isIntro";
  static const String _email = "";

  static Future<void> initializeDefaults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_permission) == null) {
      await prefs.setBool(_permission, false);
    }
  }

  static setIsIntro(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isIntro, sizes);
  }

  static getIsIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isIntro) ?? true;
    return intValue;
  }

  // Store the username
  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // Retrieve the username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  // Store the user ID
  static Future<void> setUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idKey, id);
  }

  // Retrieve the user ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idKey);
  }

  // Store login status as a boolean
  static Future<void> setIsPermitted(bool isPermitted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permission, isPermitted);
  }

  // Retrieve login status as a boolean
  static Future<bool?> getIsPermitted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permission);
  }

  // Clear all session data (e.g., on logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_idKey);
    await prefs.remove(_permission);
    await prefs.remove(_email);
  }

  static Future<String> getUsernameText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? "No Username"; // Fallback if null
  }

  static Future<String> getEmailText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email) ?? "No Email"; // Fallback if null
  }

  static Future<int> getIdText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idKey) ?? 0;
  }
}