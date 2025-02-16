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
    body: json.encode({"user_id": userId, "tracks": null}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("DATA: $data");

    return (data["songs"] as List<dynamic>).map((track) {
      return {
        "track_id": track["track_id"]?.toString() ?? "",
        "yt_track_id": track["yt_track_id"]?.toString() ?? "",
        "track_name": track["track_name"]?.toString() ?? "",
        "yt_track_name": track["yt_track_name"]?.toString() ?? "",
        "audio_url": track["audio_url"]?.toString() ?? "",
        "thumbnail_url": track["thumbnail_url"]?.toString() ?? "",
        "video_url": track["video_url"]?.toString() ?? "",
      };
    }).toList();
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
  Future<Map<String, String>?> fetchYouTubeAudio(String trackId, String trackName) async {
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

  /// Remove like from a track
  Future<void> unlikeTrack(String trackId) async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't unlike track.");
      return;
    }

    final url = Uri.parse("$baseUrl/interactions/unlike");
    final body = json.encode({"user_id": userId, "track_id": trackId});

    print("API Request: POST $url");
    print("Request Body: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to unlike track");
    }
  }

  /// Check if a track is liked by the user
  Future<bool> isTrackLiked(String trackId) async {
    final userId = await getUserId();
    if (userId == null) return false;

    final url = Uri.parse("$baseUrl/interactions/like/status?user_id=$userId&track_id=$trackId");
    try {
      print("API Request: GET $url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['is_liked'] ?? false;
      }
      return false;
    } catch (e) {
      print("❌ Error checking if track is liked: $e");
      return false;
    }
  }

  /// Check if a track is saved by the user
  Future<bool> isTrackSaved(String trackId) async {
    final userId = await getUserId();
    if (userId == null) return false;

    final url = Uri.parse("$baseUrl/users/$userId/saved/$trackId/status");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['is_saved'] ?? false;
      }
      return false;
    } catch (e) {
      print("❌ Error checking if track is saved: $e");
      return false;
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



  /// ✅ Logout user (removes `user_id` from local storage)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    print("✅ User logged out.");
  }

  /// ✅ Register a new user
  Future<void> registerUser(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/register");
    print("API Request: POST $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id", data["user_id"]);
      } else if (response.statusCode == 409) {
        throw Exception("Username already taken");
      } else {
        throw Exception("Registration failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Registration error: $e");
      throw e;
    }
  }

  /// Track user interactions: scrolling
  /// Fetch user profile data including metrics and activity

  Future<Map<String, String>> fetchUserProfile(int userId) async {
    final url = Uri.parse("$baseUrl/users/$userId/profile");
    print("API Request: GET $url");

    try {
      final response = await http.get(url);
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          "user_id": data["user_id"]?.toString() ?? "",
          "username": data["username"] ?? "Unknown User",
          "total_likes": data["total_likes"]?.toString() ?? "0",
          "total_saves": data["total_saves"]?.toString() ?? "0",
        };
      } else {
        print("❌ Failed to fetch user profile: ${response.statusCode}");
        return {}; // Return empty map on failure
      }
    } catch (e) {
      print("❌ Error fetching user profile: $e");
      return {}; // Return empty map on failure
    }
  }
  /// Fetch user's learning history

  Future<List<Map<String, String>>> fetchUserHistory(int userId) async {
    final url = Uri.parse("$baseUrl/users/$userId/history");
    print("API Request: GET $url");

    try {
      final response = await http.get(url);
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return List<Map<String, String>>.from(
          data.map(
            (history) => {
              "track_id": history["track_id"]?.toString() ?? "Unknown Track",
              "track_name": history["track_name"] ?? "Unknown Title",
              "yt_track_name": history["yt_track_name"] ?? "",
              "yt_track_id": history["yt_track_id"] ?? "",
              "audio_url": history["audio_url"] ?? "",
              "thumbnail_url": history["thumbnail_url"] ?? "",
              "video_url": history["video_url"] ?? "",
              "timestamp": history["timestamp"]?.toString() ?? "",
            },
          ),
        );
      } else {
        print("❌ Failed to fetch user history: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching user history: $e");
      return [];
    }
  }


  /// ✅ Logout user from backend and clear local storage
  Future<void> logoutUser() async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't log out.");
      return;
    }

    final url = Uri.parse("$baseUrl/auth/logout?user_id=$userId");
    print("API Request: POST $url");

    final response = await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("user_id"); // ✅ Remove from local storage
      print("✅ User logged out.");
    } else {
      throw Exception("Failed to log out: ${response.statusCode}");
    }
  }
  
  Future<void> deleteAccount() async {
    final userId = await getUserId();
    if (userId == null) {
      print("❌ No user_id found. Can't delete account.");
      return;
    }

    final url = Uri.parse("$baseUrl/auth/delete?user_id=$userId");
    print("API Request: DELETE $url");

    final response = await http.delete(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("user_id"); // ✅ Remove from local storage
      print("✅ User account deleted.");
    } else {
      throw Exception("Failed to delete account: ${response.statusCode}");
    }
  }


}