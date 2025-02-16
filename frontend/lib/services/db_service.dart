import 'dart:convert';
import 'package:http/http.dart' as http;

class DbService {
  static const String baseUrl = "http://10.0.2.2:5000/db";

  static Future<void> addTrack(Map<String, String> trackData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_track"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(trackData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add track");
    }
  }

  static Future<void> addUser(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add user");
    }
  }

  static Future<void> addListen(Map<String, String> listenData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_listen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listenData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to record listen");
    }
  }

  static Future<void> addLike(Map<String, String> likeData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_like"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(likeData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to record like");
    }
  }

  static Future<void> addSave(Map<String, String> saveData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(saveData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to record save");
    }
  }

  static Future<void> addLessonPlan(Map<String, String> lessonPlanData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_lesson_plan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lessonPlanData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add lesson plan");
    }
  }
}
