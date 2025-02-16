import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../components/music_card.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Music Discovery"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by Instrument (e.g., Violin)",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    musicProvider.searchMusic(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: musicProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: musicProvider.musicList.length,
                    itemBuilder: (context, index) {
                      return MusicCard(musicProvider.musicList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
