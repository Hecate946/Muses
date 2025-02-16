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
              musicProvider.stopAudio();
              Future.delayed(Duration(milliseconds: 50), () {
                musicProvider.playTrack(index);
              });
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
            top: 40,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Music Discovery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
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
                SizedBox(width: 8), // Add some padding on the right
              ],
            ),
          ),
        ],
      ),
    );
  }
}
