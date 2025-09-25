import 'dart:convert';
import '../models/event.dart';
import 'api_service.dart';
import 'auth_service.dart';

class EventService {
  static Future<List<Event>> fetchEvents() async {
    try {
      final token = await AuthService.getToken();
      final response = await ApiService.get("/api/events", token: token);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception("Erreur ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur réseau: $e");
    }
  }

  static Future<bool> createEvent(Event event, String token) async {
    try {
      final response = await ApiService.post(
        "/api/events",
        event.toJson(),
        token: token,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteEvent(int eventId, String token) async {
    try {
      final response = await ApiService.delete(
        "/api/events/$eventId",
        token: token,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}