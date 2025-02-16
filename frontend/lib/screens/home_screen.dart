import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/music_provider.dart';
import '../components/music_card.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentAudioUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setVolume(1.0); // ✅ Set volume to max
    Future.delayed(Duration.zero, () {
      Provider.of<MusicProvider>(context, listen: false).searchMusic("violin");
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Fetch and play audio when a new track is swiped
  void _playNewTrack(String trackTitle) async {
    setState(() {
      isLoading = true;
    });

    print("Fetching YouTube audio for: $trackTitle");

    final audioData = await apiService.fetchYouTubeAudio(trackTitle);

    if (audioData != null && audioData["audio_url"] != null) {
      _currentAudioUrl = audioData["audio_url"];

      try {
        await _audioPlayer.stop();
        await _audioPlayer.setSourceUrl(_currentAudioUrl!);
        await _audioPlayer.setVolume(1.0); // ✅ Increase volume
        await _audioPlayer.play(UrlSource(_currentAudioUrl!));

        print("Now playing: $trackTitle");
      } catch (e) {
        print("Error playing audio: $e");
      }
    } else {
      print("Error: No audio found for $trackTitle");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Music Discovery"),
      ),
      body: musicProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              scrollDirection: Axis.vertical, // ✅ Swipe up/down for new music
              itemCount: musicProvider.musicList.length,
              onPageChanged: (index) {
                final trackTitle = musicProvider.musicList[index]["title"];
                _playNewTrack(trackTitle);
              },
              itemBuilder: (context, index) {
                final track = musicProvider.musicList[index];

                return MusicCard(
                  musicData: track, // ✅ Pass track data
                  apiService: apiService, // ✅ Pass ApiService
                );
              },
            ),
    );
  }
}
