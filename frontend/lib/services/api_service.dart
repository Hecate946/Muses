import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ApiService {
  static String get _baseHost {
    // Use 10.0.2.2 for Android emulator and localhost for iOS simulator
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }

  static String get baseUrl => 'http://$_baseHost:5000/interactions';

  Future<List<dynamic>> fetchMusicByInstrument(String instrument) async {
    final url = Uri.parse("http://$_baseHost:5000/search/musicbrainz?instrument=$instrument");
    print("API Request: GET $url");  // Debugging print

    final response = await http.get(url);

    print("Response Code: ${response.statusCode}"); // Debugging print
    print("Response Body: ${response.body}"); // Debugging print

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch music");
    }
  }

  Future<void> likeTrack(int userId, String trackId) async {
    final url = Uri.parse("$baseUrl/like");
    final body = json.encode({"user_id": userId, "track_id": trackId});
    print("API Request: POST $url"); // Debugging print
    print("Request Body: $body"); // Debugging print

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    print("Response Code: ${response.statusCode}"); // Debugging print
    print("Response Body: ${response.body}"); // Debugging print

    if (response.statusCode != 200) {
      throw Exception("Failed to like track");
    }
  }

  Future<void> trackScroll(int userId, String trackId, String startTime, String endTime) async {
    final url = Uri.parse("$baseUrl/scroll");
    final body = json.encode({
      "user_id": userId,
      "track_id": trackId,
      "start_time": startTime,
      "end_time": endTime
    });

    print("API Request: POST $url"); // Debugging print
    print("Request Body: $body"); // Debugging print

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    print("Response Code: ${response.statusCode}"); // Debugging print
    print("Response Body: ${response.body}"); // Debugging print

    if (response.statusCode != 200) {
      throw Exception("Failed to track scroll");
    }
  }
}
