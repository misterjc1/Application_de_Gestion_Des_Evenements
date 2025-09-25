import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    return await http.post(
      Uri.parse("$apiUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> get(String endpoint, {String? token}) async {
    return await http.get(
      Uri.parse("$apiUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  static Future<http.Response> delete(String endpoint, {String? token}) async {
    return await http.delete(
      Uri.parse("$apiUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}