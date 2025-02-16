import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../components/music_card.dart';
import '../services/api_service.dart';
import 'search_screen.dart';

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

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: musicProvider.queue.length,
            onPageChanged: (index) {
              print("✅ Page fully settled on index: $index");
              musicProvider.stopAudio().then((_) {
                Future.delayed(Duration(milliseconds: 50)).then((_) {
                  musicProvider.playTrack(index);
                });
              });

              if (index >= musicProvider.queue.length - 2) {
                musicProvider.fetchNextBatch();
              }
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
  top: 0, // Lowered from 40 to 20
  left: 0,
  right: 0,
  child: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      "Music Discovery",
      style: TextStyle(
        color: Colors.black87, // Matches the new cream background
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black87, // Matches new UI
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
