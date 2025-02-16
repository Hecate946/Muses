import 'package:flutter/material.dart';
import '../services/api_service.dart';
 
import '../services/api_service.dart';
 
class Song {
  final String id;
  final String title;
  final String artist;
  final String difficulty;
  final String genre;
  final String duration;
 
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.difficulty,
    required this.genre,
    required this.duration,
  });
}
 
class SongsToLearnScreen extends StatefulWidget {
  @override
  _SongsToLearnScreenState createState() => _SongsToLearnScreenState();
}
 
class _SongsToLearnScreenState extends State<SongsToLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Song> recommendedSongs = [];
  List<Song> savedSongs = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();
 
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSongs();
  }
 
  Future<void> _loadSongs() async {
    setState(() => isLoading = true);
    try {
      
      final recommendedData = await _apiService.fetchRecommendedSongs();
      final savedData = await _apiService.fetchSavedSongs();

      setState(() {
        recommendedSongs = recommendedData.map((data) {
          try {
            return Song(
              id: (data['id'] ?? '').toString(),
              title: (data['title'] ?? 'Untitled').toString(),
              artist: (data['artist'] ?? 'Unknown Artist').toString(),
              difficulty: (data['difficulty'] ?? 'Unknown').toString(),
              genre: (data['genre'] ?? 'Unknown').toString(),
              duration: (data['duration'] ?? 'Unknown').toString(),
            );
          } catch (e) {
            print('Error parsing recommended song data: $data');
            print('Error details: $e');
            return null;
          }
        }).whereType<Song>().toList();
 
        savedSongs = savedData.map((data) {
          try {
            return Song(
              id: (data['id'] ?? '').toString(),
              title: (data['title'] ?? 'Untitled').toString(),
              artist: (data['artist'] ?? 'Unknown Artist').toString(),
              difficulty: (data['difficulty'] ?? 'Unknown').toString(),
              genre: (data['genre'] ?? 'Unknown').toString(),
              duration: (data['duration'] ?? 'Unknown').toString(),
            );
          } catch (e) {
            print('Error parsing saved song data: $data');
            print('Error details: $e');
            return null;
          }
        }).whereType<Song>().toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load songs: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
 
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
 
  void _showSongDetails(Song song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(song.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artist: ${song.artist}'),
            SizedBox(height: 8),
            Text('Genre: ${song.genre}'),
            SizedBox(height: 8),
            Text('Difficulty: ${song.difficulty}'),
            SizedBox(height: 8),
            Text('Duration: ${song.duration}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement start learning functionality
              Navigator.pop(context);
            },
            child: Text('Start Learning'),
          ),
        ],
      ),
    );
  }
 
  Widget _buildSongList(List<Song> songs) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
 
    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No songs available yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Songs will appear here as you interact with the app',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
 
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          title: Text(song.title,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(song.artist,
              overflow: TextOverflow.ellipsis),
          trailing: Text(song.difficulty),
          onTap: () => _showSongDetails(song),
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs to Learn'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Recommended'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSongList(recommendedSongs),
                  _buildSongList(savedSongs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}