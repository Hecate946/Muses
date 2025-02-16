import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ApiService {
  static String get _baseHost {
    // Use 10.0.2.2 for Android emulator and localhost for iOS simulator
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }

  static String get baseUrl => 'http://$_baseHost:5000/';

  /// Fetch a list of music tracks based on instrumentation
  Future<List<dynamic>> fetchMusicByInstrument(String instrument) async {
    final url = Uri.parse("http://$_baseHost:5000/search/musicbrainz?instrument=$instrument");
    print("API Request: GET $url");  // Debugging print

    final response = await http.get(url);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch music");
    }
  }

  /// Fetch YouTube audio URL from the backend
  Future<Map<String, dynamic>?> fetchYouTubeAudio(String trackTitle) async {
    final url = Uri.parse("$baseUrl/playback/youtube/audio?track=$trackTitle");
    print("API Request: GET $url");

    final response = await http.get(url);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch YouTube audio: ${response.statusCode}");
      return null;
    }
  }

  /// Fetch recommended songs for a user
  Future<List<dynamic>> fetchRecommendedSongs(int userId) async {
    final url = Uri.parse("http://$_baseHost:5000/recommendations?user_id=$userId");
    print("API Request: GET $url");

    final response = await http.get(url);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print("Decoded Data: $decodedData");
      return decodedData is List ? decodedData : [];
    } else {
      throw Exception("Failed to fetch recommended songs: ${response.statusCode}");
    }
  }

  /// Fetch saved/liked songs for a user
  Future<List<dynamic>> fetchSavedSongs(int userId) async {
    final url = Uri.parse("http://$_baseHost:5000/saved-songs?user_id=$userId");
    print("API Request: GET $url");

    final response = await http.get(url);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print("Decoded Data: $decodedData");
      return decodedData is List ? decodedData : [];
    } else {
      throw Exception("Failed to fetch saved songs: ${response.statusCode}");
    }
  }

  /// Track user interactions: likes
  Future<void> likeTrack(int userId, String trackId) async {
    final url = Uri.parse("$baseUrl/interactions/like");
    final body = json.encode({"user_id": userId, "track_id": trackId});

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to like track");
    }
  }

  /// Track user interactions: scrolling
  Future<void> trackScroll(int userId, String trackId, String startTime, String endTime) async {
    final url = Uri.parse("$baseUrl/interactions/scroll");
    final body = json.encode({
      "user_id": userId,
      "track_id": trackId,
      "start_time": startTime,
      "end_time": endTime
    });

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to track scroll");
    }
  }
}
