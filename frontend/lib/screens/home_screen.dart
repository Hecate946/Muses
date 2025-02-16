import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../components/music_card.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MusicProvider>(context, listen: false).initializeQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Music Discovery"),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical, // ✅ Swipe up/down for new music
        itemCount: musicProvider.queue.length,
        onPageChanged: (index) {
          print("✅ Page fully settled on index: $index");
          musicProvider.stopAudio(); // ✅ Stop old track exactly when the new page is in place
          Future.delayed(Duration(milliseconds: 50), () {
            musicProvider.playTrack(index); // ✅ Play the new track slightly after stopping the old one
          });
        },
        itemBuilder: (context, index) {
          final track = musicProvider.queue[index];

          return MusicCard(
            musicData: track, // ✅ Uses structured queue data
            apiService: apiService,
          );
        },
      ),
    );
  }
}
