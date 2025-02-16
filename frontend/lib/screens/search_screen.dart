import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/music_provider.dart';
import '../main.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        hintText: 'Search for songs, genre, instruments...',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          try {
                            var results = await apiService.fetchMusicByInstrument(value);
                            print("Fetched search results: $results");
                            // You can update the provider or state with results here
                          } catch (e) {
                            print("Error fetching search results: $e");
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 56, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You may like',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                final recommendations = [
                  {
                    'title': 'Symphony No. 40 in G minor',
                    'instrumentation': 'Wolfgang Amadeus Mozart - Orchestra',
                    'image': 'https://i.ytimg.com/vi/jgpJVI3tDbY/mqdefault.jpg',
                    'videoId': 'jgpJVI3tDbY'
                  },
                  {
                    'title': 'Moonlight Sonata',
                    'instrumentation': 'Ludwig van Beethoven - Piano',
                    'image': 'https://i.ytimg.com/vi/c1iZXyWLnXg/mqdefault.jpg',
                    'videoId': 'c1iZXyWLnXg'
                  },
                  {
                    'title': 'Violin Concerto in E major',
                    'instrumentation': 'Johann Sebastian Bach - Violin & Orchestra',
                    'image': 'https://i.ytimg.com/vi/6JQm5aSjX6g/mqdefault.jpg',
                    'videoId': '6JQm5aSjX6g'
                  },
                  {
                    'title': 'String Quartet No. 14 in D minor',
                    'instrumentation': 'Franz Schubert - Chamber Ensemble',
                    'image': 'https://i.ytimg.com/vi/13ygvpIg-S0/mqdefault.jpg',
                    'videoId': '13ygvpIg-S0'
                  },
                  {
                    'title': 'Brandenburg Concerto No. 3',
                    'instrumentation': 'Johann Sebastian Bach - Orchestra',
                    'image': 'https://i.ytimg.com/vi/SaCheA6Njc4/mqdefault.jpg',
                    'videoId': 'SaCheA6Njc4'
                  },
                ];
                final item = recommendations[index];
                return InkWell(
                  onTap: () {
                    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
                    musicProvider.addToQueue({
                      'title': item['title'] ?? '',
                      'instrumentation': item['instrumentation'] ?? '',
                      'videoId': item['videoId'] ?? '',
                      'thumbnailUrl': item['image'] ?? '',
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            item['image']!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey[300],
                                child: Icon(Icons.music_note, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

