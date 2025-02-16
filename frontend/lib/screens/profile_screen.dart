import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample data for demonstration
  final List<Map<String, String>> _likedSongs = [
    {'title': 'Song 1', 'genre': 'Genre'},
    {'title': 'Song 2', 'genre': 'Genre'},
    {'title': 'Song 3', 'genre': 'Genre'},
    {'title': 'Song 4', 'genre': 'Genre'},
  ];

  final List<String> _instruments = ['Instrument 1', 'Instrument 2', 'Instrument 3'];

  final List<Map<String, String>> _yourSongs = [
    {'title': 'Song 1', 'genre': 'Genre'},
    {'title': 'Song 2', 'genre': 'Genre'},
    {'title': 'Song 3', 'genre': 'Genre'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Icon(Icons.person, size: 50, color: Colors.deepPurple.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            /// YOUR LIKES SECTION
            const Text(
              'Your Likes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _likedSongs
                    .map(
                      (songData) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildSongSquare(
                          songData['title']!,
                          songData['genre']!,
                          color: Colors.purple.shade100,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            /// YOUR INSTRUMENTS SECTION
            const Text(
              'Your Instruments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _instruments
                    .map(
                      (instrument) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildInstrumentSquare(
                          instrument,
                          color: Colors.purple.shade50,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            /// YOUR SONGS SECTION
            const Text(
              'Your Songs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _yourSongs
                    .map(
                      (songData) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildSongRectangle(
                          songData['title']!,
                          songData['genre']!,
                          color: Colors.purple.shade100,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a square-like card for a song
  Widget _buildSongSquare(String title, String genre, {Color? color}) {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(genre, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a square-like card for an instrument
  Widget _buildInstrumentSquare(String instrument, {Color? color}) {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          instrument,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Helper widget to build a rectangular card for "Your Songs"
  Widget _buildSongRectangle(String title, String genre, {Color? color}) {
    return Container(
      width: 80,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(genre, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
