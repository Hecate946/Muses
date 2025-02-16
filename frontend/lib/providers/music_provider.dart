import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _musicList = [];
  bool _isLoading = false;

  List<dynamic> get musicList => _musicList;
  bool get isLoading => _isLoading;

  MusicProvider() {
    // Automatically load music when the provider initializes
    searchMusic("violin");
  }

  Future<void> searchMusic(String instrument) async {
    _isLoading = true;
    notifyListeners();

    print("Fetching music for instrument: $instrument"); // Debugging print

    try {
      _musicList = await _apiService.fetchMusicByInstrument(instrument);
      print("Fetched ${_musicList.length} tracks"); // Debugging print
    } catch (e) {
      print("Error fetching music: $e"); // Debugging print
      _musicList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
