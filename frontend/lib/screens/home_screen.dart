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
  final ApiService apiService = ApiService(); // Ensure ApiService instance

  @override
  void initState() {
    super.initState();
    // Automatically fetch music for "violin" on app startup
    Future.delayed(Duration.zero, () {
      Provider.of<MusicProvider>(context, listen: false).searchMusic("violin");
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
              scrollDirection: Axis.vertical,
              itemCount: musicProvider.musicList.length,
              itemBuilder: (context, index) {
                return MusicCard(
                  musicData: musicProvider.musicList[index], // Pass musicData
                  apiService: apiService, // Pass apiService
                );
              },
            ),
    );
  }
}
