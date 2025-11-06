import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  // static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';

  /// Save tokens
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    // await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Save user info (whole user JSON)
  static Future<void> saveUser(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userJson));
  }

  /// Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get stored refresh token
  // static Future<String?> getRefreshToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_refreshTokenKey);
  // }

  /// Get stored user as Map
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  /// Clear everything
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    // await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }
}