import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await ApiService.post("/api/login", {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data['token']);
        await prefs.setString("user", jsonEncode(data['user']));
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> register(String email, String password, String name, String type) async {
    try {
      final response = await ApiService.post("/api/register", {
        "email": email,
        "password": password,
        "name": name,
        "type": type,
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user");
  }
}