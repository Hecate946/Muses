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

  // Authentication Methods
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('username', username);
        await prefs.setString('token', data['token'] ?? '');
        return data;
      } else {
        throw Exception(json.decode(response.body)['error'] ?? 'Login failed');
      }
    } catch (e) {
      print("Error during login: $e");
      throw Exception("Login failed. Please try again.");
    }
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('username', username);
        await prefs.setString('token', data['token'] ?? '');
        return data;
      } else if (response.statusCode == 409) {
        throw Exception("Username already taken");
      } else {
        throw Exception(json.decode(response.body)['error'] ?? 'Registration failed');
      }
    } catch (e) {
      print("Error during registration: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    final userId = await getUserId();
    if (userId == null) return;

    try {
      final url = Uri.parse("$baseUrl/auth/logout?user_id=$userId");
      final response = await http.post(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('username');
        await prefs.remove('token');
      } else {
        throw Exception("Failed to logout");
      }
    } catch (e) {
      print("Error during logout: $e");
      throw Exception("Failed to logout");
    }
  }

  Future<void> deleteAccount() async {
    final userId = await getUserId();
    if (userId == null) return;

    try {
      final url = Uri.parse("$baseUrl/auth/delete?user_id=$userId");
      final response = await http.delete(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('username');
        await prefs.remove('token');
      } else {
        throw Exception("Failed to delete account");
      }
    } catch (e) {
      print("Error deleting account: $e");
      throw Exception("Failed to delete account");
    }
  }

  // User Data Methods
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id') && prefs.containsKey('token');
  }

  Future<Map<String, dynamic>> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt('user_id'),
      'username': prefs.getString('username'),
      'token': prefs.getString('token'),
    };
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // User Profile Methods
  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    final url = Uri.parse("$baseUrl/users/$userId/profile");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "user_id": data["user_id"]?.toString() ?? "",
          "username": data["username"] ?? "Unknown User",
          "total_interactions": data["total_interactions"] ?? 0,
          "recent_activity": List<Map<String, dynamic>>.from(
            (data["recent_activity"] ?? []).map(
              (activity) => {
                "track_id": activity["track_id"]?.toString() ?? "Unknown Track",
                "action": activity["action"]?.toString() ?? "Unknown Action",
                "timestamp": activity["timestamp"]?.toString() ?? "",
              },
            ),
          ),
        };
      } else {
        print("Failed to fetch user profile: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserHistory(int userId) async {
    final url = Uri.parse("$baseUrl/users/$userId/history");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(
          data.map(
            (history) => {
              "track_id": history["track_id"]?.toString() ?? "Unknown Track",
              "action": history["action"]?.toString() ?? "Unknown Action",
              "timestamp": history["timestamp"]?.toString() ?? "",
            },
          ),
        );
      } else {
        print("Failed to fetch user history: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching user history: $e");
      return [];
    }
  }

  // Music Methods
  Future<List<Map<String, String>>> fetchNextBatch() async {
    final userId = await getUserId();
    if (userId == null) {
      print("No user_id found. Can't fetch next batch.");
      return [];
    }

    final uri = Uri.parse("$baseUrl/playback/youtube/audio_batch");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_id": userId, "tracks": null}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, String>>.from(
        data["songs"].map<Map<String, String>>((song) => {
              "track_id": song["track_id"]?.toString() ?? "",
              "track_name": song["track_name"]?.toString() ?? "",
              "audio_url": song["audio_url"]?.toString() ?? "",
            }),
      );
    } else {
      print("Failed to fetch next batch: ${response.statusCode}");
      return [];
    }
  }

  Future<List<dynamic>> fetchMusicByInstrument(String instrument) async {
    final url = Uri.parse("$baseUrl/search/musicbrainz?instrument=$instrument");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch music");
    }
  }

  Future<Map<String, dynamic>?> fetchYouTubeAudio(String trackId, String trackName) async {
    final userId = await getUserId();
    if (userId == null) return null;

    final url = Uri.parse("$baseUrl/playback/youtube/audio?user_id=$userId&track_id=$trackId&track_name=${Uri.encodeComponent(trackName)}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch YouTube audio: ${response.statusCode}");
      return null;
    }
  }

  Future<List<dynamic>> fetchRecommendedSongs() async {
    final userId = await getUserId();
    if (userId == null) return [];

    final url = Uri.parse("$baseUrl/recommendations?user_id=$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch recommended songs: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> fetchSavedSongs() async {
    final userId = await getUserId();
    if (userId == null) return [];

    final url = Uri.parse("$baseUrl/saved-songs?user_id=$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch saved songs: ${response.statusCode}");
    }
  }

  // User Interaction Methods
  Future<void> likeTrack(String trackId, String trackName) async {
    final userId = await getUserId();
    if (userId == null) return;

    final url = Uri.parse("$baseUrl/interactions/like");
    final body = json.encode({
      "user_id": userId,
      "track_id": trackId,
      "track_name": trackName
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to like track");
    }
  }

  Future<void> trackScroll(String trackId, String trackName, String startTime, String endTime) async {
    final userId = await getUserId();
    if (userId == null) return;

    final url = Uri.parse("$baseUrl/interactions/scroll");
    final body = json.encode({
      "user_id": userId,
      "track_id": trackId,
      "track_name": trackName,
      "start_time": startTime,
      "end_time": endTime
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to track scroll");
    }
  }
}
