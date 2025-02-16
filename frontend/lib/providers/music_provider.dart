import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _musicList = [];
  bool _isLoading = false;

  List<dynamic> get musicList => _musicList;
  bool get isLoading => _isLoading;

  Future<void> searchMusic(String instrument) async {
    _isLoading = true;
    notifyListeners();

    try {
      _musicList = await _apiService.fetchMusicByInstrument(instrument);
    } catch (e) {
      _musicList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
