import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search for songs, genre, instruments, artist...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Provider.of<MusicProvider>(context, listen: false)
                              .searchMusic(value);
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
        padding: EdgeInsets.only(left: 56, right: 16, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You may like',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            // Sample recommended songs - you can replace these with actual user preferences
            ...List.generate(5, (index) {
              final songData = [
                {
                  'title': 'Classical Symphony Orchestra',
                  'thumbnail': 'https://i.ytimg.com/vi/DAyUzxDB9eE/hqdefault.jpg',
                },
                {
                  'title': 'Piano Sonatas Collection',
                  'thumbnail': 'https://i.ytimg.com/vi/c1iZXyWLnXg/hqdefault.jpg',
                },
                {
                  'title': 'Violin Concertos Masterpieces',
                  'thumbnail': 'https://i.ytimg.com/vi/6JQm5aSjX6g/hqdefault.jpg',
                },
                {
                  'title': 'Chamber Music Ensemble',
                  'thumbnail': 'https://i.ytimg.com/vi/13ygvpIg-S0/hqdefault.jpg',
                },
                {
                  'title': 'Baroque Period Highlights',
                  'thumbnail': 'https://i.ytimg.com/vi/SaCheA6Njc4/hqdefault.jpg',
                },
              ];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      songData[index]['thumbnail']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.music_note, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    songData[index]['title']!,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Provider.of<MusicProvider>(context, listen: false)
                        .searchMusic(songData[index]['title']!);
                    Navigator.pop(context);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
