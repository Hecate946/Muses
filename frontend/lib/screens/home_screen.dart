import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../components/music_card.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userId = 1; // Replace with actual user ID from authentication
  String? currentTrackId;
  DateTime? startTime;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MusicProvider>(context, listen: false).initializeQueue();
    });
  }

  Future<void> _storeTrackData(Map<String, String> track) async {
    try {
      await DbService.addTrack(track);
    } catch (e) {
      print("Error storing track data: $e");
    }
  }

  Future<void> _logScrollInteraction(Map<String, String> track) async {
    DateTime endTime = DateTime.now().toUtc();

    if (currentTrackId != null && startTime != null) {
      await DbService.addListen({
        "user_id": userId.toString(),
        "track_id": currentTrackId!,
        "start_time": startTime!.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      });
    }

    currentTrackId = track["track_id"];
    startTime = DateTime.now().toUtc();

    await _storeTrackData(track);
  }

  Future<void> _logLike(Map<String, String> track) async {
    try {
      await DbService.addLike({
        "user_id": userId.toString(),
        "track_id": track["track_id"] ?? '',
        "timestamp": DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      print("Error recording like: $e");
    }
  }

  Future<void> _logSave(Map<String, String> track) async {
    try {
      await DbService.addSave({
        "user_id": userId.toString(),
        "track_id": track["track_id"]!,
        "timestamp": DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      print("Error recording save: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: musicProvider.queue.length,
            onPageChanged: (index) async {
              print("✅ Page fully settled on index: $index");
              musicProvider.stopAudio();
              Future.delayed(Duration(milliseconds: 50), () {
                musicProvider.playTrack(index);
              });

              if (index >= musicProvider.queue.length - 2) {
                musicProvider.fetchNextBatch();
              }

              final track = musicProvider.queue[index];

              print("TRACK: $track");

              await _logScrollInteraction(track);
            },
            itemBuilder: (context, index) {
              final track = musicProvider.queue[index];
              return MusicCard(
                musicData: track,
                apiService: apiService,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Music Discovery",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black87,
                    size: 32,
                  ),
                  padding: EdgeInsets.all(8),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
