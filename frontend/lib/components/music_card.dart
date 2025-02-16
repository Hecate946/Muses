import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MusicCard extends StatelessWidget {
  final dynamic musicData;
  final ApiService apiService;

  MusicCard({required this.musicData, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/music_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            musicData["track_name"] ?? "Unknown Title", // ✅ Changed from "title" to "track_name"
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            musicData["instrumentation"] ?? "Unknown Instrumentation",
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              apiService.likeTrack(musicData["track_id"], musicData["track_name"]); // ✅ Pass both track_id & track_name
            },
          ),
        ],
      ),
    );
  }
}
