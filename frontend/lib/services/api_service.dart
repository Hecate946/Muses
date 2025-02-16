import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get _baseHost {
    // Use 10.0.2.2 for Android emulator and localhost for iOS simulator
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }

  static String get baseUrl => 'http://$_baseHost:5000';

  /// ✅ Get stored `user_id` from local storage
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // Fetches user_id from storage
  }

  /// ✅ Fetch the next 5 songs from the backend using track_id and track_name
  Future<List<Map<String, String>>> fetchNextBatch() async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't fetch next batch.");
      return [];
    }

    final uri = Uri.parse("$baseUrl/playback/youtube/audio_batch");
    print("API Request: POST $uri");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_id": userId, "tracks": null}), // ✅ Allow backend to generate batch
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return List<Map<String, String>>.from(
        data["songs"].map<Map<String, String>>((song) => {
              "track_id": song["track_id"]?.toString() ?? "",   // ✅ Ensure it's a string
              "track_name": song["track_name"]?.toString() ?? "", // ✅ Convert null to empty string
              "audio_url": song["audio_url"]?.toString() ?? "", // ✅ Convert null to empty string
            }),
      );
    } else {
      print("❌ Failed to fetch next batch: ${response.statusCode}");
      return [];
    }
  }



  /// ✅ Fetch a list of music tracks based on instrumentation
  Future<List<dynamic>> fetchMusicByInstrument(String instrument) async {
    final url = Uri.parse("$baseUrl/search/musicbrainz?instrument=$instrument");
    print("API Request: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch music");
    }
  }

  /// ✅ Fetch YouTube audio URL using track_id and track_name
  Future<Map<String, dynamic>?> fetchYouTubeAudio(String trackId, String trackName) async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't fetch YouTube audio.");
      return null;
    }

    final url = Uri.parse("$baseUrl/playback/youtube/audio?user_id=$userId&track_id=$trackId&track_name=${Uri.encodeComponent(trackName)}");
    print("API Request: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch YouTube audio: ${response.statusCode}");
      return null;
    }
  }

  /// ✅ Fetch recommended songs for a user
  Future<List<dynamic>> fetchRecommendedSongs() async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't fetch recommendations.");
      return [];
    }

    final url = Uri.parse("$baseUrl/recommendations?user_id=$userId");
    print("API Request: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch recommended songs: ${response.statusCode}");
    }
  }

  /// ✅ Fetch saved/liked songs for a user
  Future<List<dynamic>> fetchSavedSongs() async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't fetch saved songs.");
      return [];
    }

    final url = Uri.parse("$baseUrl/saved-songs?user_id=$userId");
    print("API Request: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch saved songs: ${response.statusCode}");
    }
  }

  /// ✅ Track user interactions: likes
  Future<void> likeTrack(String trackId, String trackName) async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't like track.");
      return;
    }

    final url = Uri.parse("$baseUrl/interactions/like");
    final body = json.encode({"user_id": userId, "track_id": trackId, "track_name": trackName});

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw Exception("Failed to like track");
    }
  }

  /// ✅ Track user interactions: scrolling
  Future<void> trackScroll(String trackId, String trackName, String startTime, String endTime) async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't track scroll.");
      return;
    }

    final url = Uri.parse("$baseUrl/interactions/scroll");
    final body = json.encode({
      "user_id": userId,
      "track_id": trackId,
      "track_name": trackName,
      "start_time": startTime,
      "end_time": endTime
    });

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw Exception("Failed to track scroll");
    }
  }

  /// ✅ Register user and store `user_id` in local storage
  Future<void> registerUser(String username) async {
    final url = Uri.parse("$baseUrl/auth/register");
    final body = json.encode({"username": username});

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int userId = data["user_id"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("user_id", userId);

      print("✅ User registered with ID: $userId");
    } else {
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  /// ✅ Logout user (removes `user_id` from local storage)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    print("✅ User logged out.");
  }
}
