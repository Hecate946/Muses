import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'lesson_plan_screen.dart';
import '../components/muses_app_bar.dart';
 
class Song {
  final String id;
  final String title;
  final String artist;
  final String difficulty;
  final String genre;
  final String duration;
  final String lessonId;
  final String description;
 
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.difficulty,
    required this.genre,
    required this.duration,
    required this.lessonId,
    required this.description,
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
        recommendedSongs = [
          Song(
            id: 'moonlight_sonata',
            title: 'Moonlight Sonata - 1st Movement',
            artist: 'Ludwig van Beethoven',
            difficulty: 'Intermediate',
            genre: 'Classical',
            duration: '5:30',
            lessonId: 'moonlight_sonata',
            description: 'A haunting and beautiful piece composed in 1801. This lesson focuses on the famous first movement, teaching proper fingering, pedaling, and dynamic control.',
          ),
          Song(
            id: 'lose_yourself',
            title: 'Lose Yourself',
            artist: 'Eminem',
            difficulty: 'Beginner',
            genre: 'Hip Hop',
            duration: '5:26',
            lessonId: 'lose_yourself',
            description: 'An iconic hip-hop track from 2002. Learn the famous piano riff that underlies this motivational anthem, focusing on rhythm and chord progressions.',
          ),
        ];
        
        // Initialize saved songs list with Bach's Prelude
        savedSongs = [
          Song(
            id: 'bach_prelude',
            title: 'Prelude in C Major (BWV 846)',
            artist: 'Johann Sebastian Bach',
            difficulty: 'Beginner',
            genre: 'Classical',
            duration: '2:30',
            lessonId: 'bach_prelude',
            description: 'The first prelude from Bach\'s Well-Tempered Clavier is a perfect introduction to Baroque music. Its repeating pattern makes it accessible while teaching essential piano techniques.',
          ),
        ];
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Artist: ${song.artist}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(song.description),
              SizedBox(height: 12),
              Text('Genre: ${song.genre}'),
              SizedBox(height: 8),
              Text('Difficulty: ${song.difficulty}'),
              SizedBox(height: 8),
              Text('Duration: ${song.duration}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonPlanScreen(
                    songId: song.lessonId,
                    title: '${song.title} - Lesson Plan',
                  ),
                ),
              );
            },
            child: Text('Start Learning'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
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
      backgroundColor: Colors.grey[50],
      appBar: MusesAppBar(
        title: 'Songs to Learn',
        showLogo: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Recommended'),
                  Tab(text: 'Saved'),
                ],
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black87,
              ),
            ),
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