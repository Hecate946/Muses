import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Map<String, String>> _queue = [];
  bool _isLoading = false;
  String? _currentAudioUrl;
  int _currentIndex = -1;

  List<Map<String, String>> get queue => _queue;
  bool get isLoading => _isLoading;
  String? get currentAudioUrl => _currentAudioUrl;

  MusicProvider() {
    initializeQueue(); // ✅ Start by fetching the first batch of songs
  }

  /// Initializes the queue with tracks from the backend
  Future<void> initializeQueue() async {
    if (_queue.isEmpty) {
      await fetchNextBatch();
      if (_queue.isNotEmpty) {
        playTrack(0);
      }
    } else {
      playTrack(0);
    }
    notifyListeners();
  }

  void addToQueue(Map<String, String> track) {
    _queue.insert(0, {
      'track_id': track['videoId'] ?? '',
      'track_name': track['title'] ?? '',
      'instrumentation': track['instrumentation'] ?? '',
      'thumbnailUrl': track['thumbnailUrl'] ?? '',
      'videoId': track['videoId'] ?? '',
    });
    playTrack(0);
    notifyListeners();
  }

  /// ✅ Fetches the next 5 songs from the backend using track_id and track_name
  Future<void> fetchNextBatch() async {
    if (_isLoading) return; // Prevent duplicate requests
    _isLoading = true;
    notifyListeners();


    try {
      final newTracks = await _apiService.fetchNextBatch();
      if (newTracks.isNotEmpty) {
        _queue.addAll(newTracks.map((track) => {
              "track_id": track["track_id"] ?? "",
              "track_name": track["track_name"] ?? "",
              "audio_url": track["audio_url"] ?? "",
              "video_id": track["video_id"] ?? "",
              "video_url": track["video_url"] ?? "",  // Add video_url mapping
              "thumbnail_url": track["thumbnail_url"] ?? "",
            }));
        print("✅ Prefetched next batch (${newTracks.length} songs)");
      } else {
        print("⚠️ No more songs available.");
      }
    } catch (e) {
      print("❌ Error fetching next batch: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Plays a new track and requests the next batch if needed
  Future<void> playTrack(int index) async {
    if (index < 0 || index >= _queue.length || index == _currentIndex) return;

    print("🎶 Switching to track: ${_queue[index]["track_name"]}");

    stopAudio();
    _currentIndex = index;
    _currentAudioUrl = null;
    notifyListeners();

    String? audioUrl = _queue[index]["audio_url"];
    String trackId = _queue[index]["track_id"]!;
    String trackName = _queue[index]["track_name"]!;

    print("🎵 Prefetched URL: $audioUrl");
    print("🎵 Prefetched URL: $trackId");
    print("🎵 Prefetched URL: $trackName");

    if (audioUrl == null || audioUrl.isEmpty) {
      print("⚠️ No prefetched URL. Fetching now...");
      final audioData = await _apiService.fetchYouTubeAudio(trackId, trackName);
      audioUrl = audioData?["audio_url"];
    }

    if (audioUrl != null && audioUrl.isNotEmpty) {
      _currentAudioUrl = audioUrl;
      print("🎵 Now playing: $_currentAudioUrl");

      try {
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);  // Ensure clean release
        await _audioPlayer.setSourceUrl(_currentAudioUrl!);  // Set audio source
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.resume();
        print("✅ Audio playback started successfully");
      } catch (e) {
        print("❌ Error setting audio source: $e");
      }
    } else {
      print("❌ Failed to get audio URL for: ${_queue[index]["track_name"]}");
    }

    // ✅ Fetch next batch when we're close to running out
    if (index >= _queue.length - 3) {
      fetchNextBatch();
    }

    notifyListeners();
  }

  /// ✅ Stops the audio instantly when a new page settles
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    notifyListeners();
  }
}
